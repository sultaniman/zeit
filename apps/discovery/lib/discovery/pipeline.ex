defmodule Discovery.Pipeline do
  @moduledoc false
  require Logger

  alias Discovery.{
    Box,
    Helpers,
    Persist,
    Request
  }

  alias Zeit.{Links, Repo}

  # Scheduled target
  def run do
    Logger.notice("Process all links")
    run(Links.stream(100))
  end

  # Can be used on-demand
  def run(enumerable_stream) do
    proxies = Helpers.get_proxies()
    timestamp = DateTime.to_unix(DateTime.utc_now())
    window = Flow.Window.count(100)

    Repo.transaction(fn ->
      enumerable_stream
      |> Flow.from_enumerable(max_demand: 100)
      |> Flow.partition(max_demand: 10, stages: 20)
      # each link to [%Box{}...]
      |> Flow.map(&box(&1, proxies, timestamp))
      # now we have [%Result{}...]
      |> Flow.partition(window: window, stages: 1)
      |> Flow.map(&Request.run/1)
      |> Flow.partition(max_demand: 10, stages: 20)
      |> Flow.map(&Persist.run/1)
      |> Flow.run()
    end)
  end

  def box(link, proxies, timestamp) do
    make_box = fn [proxy, config] ->
      %Box{
        timestamp: timestamp,
        link: link,
        proxy: proxy,
        config: config
      }
    end

    [
      %Box{
        timestamp: timestamp,
        link: link,
        proxy: nil,
        config: []
      } | Enum.map(proxies, make_box)
    ]
  end
end
