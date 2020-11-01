defmodule Discovery.Pipeline do
  @moduledoc false
  require Logger

  alias Discovery.{
    Box,
    Helpers,
    Persist,
    Request
  }

  alias Zeit.Links

  @batch_size 100

  # Scheduled target
  def run do
    Logger.notice("Process all links")

    @batch_size
    |> Links.stream()
    |> run()
  end

  # Can be used on-demand
  def run(enumerable_stream) do
    proxies = Helpers.get_proxies()
    timestamp = DateTime.to_unix(DateTime.utc_now())
    window = Flow.Window.count(@batch_size)

    enumerable_stream
    |> Flow.from_enumerable(max_demand: @batch_size)
    |> Flow.partition(max_demand: 10, stages: 20)
    # each link to [%Box{}...]
    |> Flow.map(&box(&1, proxies, timestamp))
    # now we have [%Result{}...]
    |> Flow.partition(max_demand: 10, stages: 20)
    |> Flow.map(&Request.run/1)
    |> Flow.partition(window: window, stages: 1)
    |> Flow.map(&Persist.run/1)
    |> Flow.run()
  end

  @doc """
  Creates boxed record with all required configuration to
  make request, also configures hackney pool to use for requests.
  """
  def box(link, proxies, timestamp) do
    pool = [hackney: [pool: :fetcher]]

    make_box = fn [proxy, config] ->
      %Box{
        timestamp: timestamp,
        link: link,
        proxy: proxy,
        config: Keyword.merge(config, pool)
      }
    end

    [
      %Box{
        timestamp: timestamp,
        link: link,
        proxy: nil,
        config: pool
      }
      | Enum.map(proxies, make_box)
    ]
  end
end
