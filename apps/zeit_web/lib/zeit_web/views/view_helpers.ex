defmodule ZeitWeb.ViewHelpers do
  @moduledoc false
  alias Zeit.Snapshots.Snapshot

  def domain(link) do
    if String.starts_with?(link, "http") do
      get_host(link)
    else
      get_host("https://#{link}")
    end
  end

  def nice_path(link) do
    uri = URI.parse(link)
    path = uri.path || "/"
    if uri.query do
      to_string([path, "?", URI.decode(uri.query)])
    else
      path
    end
  end

  defp get_host(url) do
    with %{host: h} <- URI.parse(url) do
      h
    end
  end

  def snapshot_status_color(%Snapshot{http_status: status}) do
    cond do
      status >= 200 and status < 300 -> "green"
      status >= 401 and status < 404 -> "blue"
      status == 400 or status >= 404 -> "red"
      true -> "blue"
    end
  end

  def format_bytes(bytes) do
    alternative_symbols = ~w(bytes Kb Mb Gb Tb Pb)

    Size.humanize!(
      bytes || 0,
      output: :string,
      round: 1,
      symbols: alternative_symbols
    )
  end
end
