defmodule Discovery.Pipeline.Pings do
  @moduledoc false
  require Logger
  alias Zeit.{Repo, Sites}

  @batch_size 100

  # Scheduled target
  def run do
    Logger.notice("NS lookup for all sites")

    @batch_size
    |> Sites.stream()
    |> run()
  end

  # Can be used on-demand
  def run(enumerable_stream) do
    Repo.transaction(fn ->
      enumerable_stream
      |> Flow.from_enumerable(max_demand: @batch_size)
      |> Flow.partition(max_demand: 10, stages: 10)
      |> Flow.map(&ping/1)
      # |> Flow.partition(max_demand: 10, stages: 10)
      # |> Flow.map(&persist/1)
      |> Flow.run()
    end)
  end

  def ping(site) do
    uri = URI.parse(site.address)
    :gen_icmp.ping(uri.host |> to_charlist())
  end

  def persist({site, result}) do
  end
end
