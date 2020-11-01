defmodule Discovery.Pipeline.Lookups do
  @moduledoc """
  NS lookup client. If lookup is successfull
  then IPv4 addresses are returned otherwise
  `lookup_error` string status will returned.
  It expects to receive HTTP URI then parses
  to extract domain to resolve host IP address.
  """
  require Logger
  alias Zeit.{Lookups, Repo, Sites}

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
      # each link to [%Box{}...]
      |> Flow.map(&lookup/1)
      # now we have [%Result{}...]
      |> Flow.partition(max_demand: 10, stages: 10)
      |> Flow.map(&persist/1)
      |> Flow.run()
    end)
  end

  def lookup(site) do
    uri = URI.parse(site.address)

    case :inet_res.gethostbyname(to_charlist(uri.host), :inet) do
      {:ok, {:hostent, _, _, _, _, ip_list}} ->
        {site, get_ips(ip_list)}

      {:error, :nxdomain} ->
        {site, "lookup_error"}
    end
  end

  def persist({site, result}) do
    Lookups.create_lookup(%{inet_address: result, site_id: site.id})
  end

  defp get_ips(ip_list) do
    ip_list
    |> Enum.map(&format_ip/1)
    |> Enum.join(",")
  end

  defp format_ip(ip_tuple) do
    ip_tuple
    |> Tuple.to_list()
    |> Enum.join(".")
  end
end
