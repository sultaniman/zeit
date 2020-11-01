defmodule ZeitWeb.Differ do
  @moduledoc false
  alias Zeit.Snapshots.Snapshot

  def calculate_diff(
        %Snapshot{http_headers: first} = s1,
        %Snapshot{http_headers: second} = s2,
        proxies
      ) do
    result =
      (first || %{})
      |> extract_headers(second || %{})
      |> Enum.map(fn h ->
        compare(h, s1, s2)
      end)

    headers = make_headers(s2, proxies)

    case maybe_errors(s1.error, s2.error) do
      nil -> [headers | result]
      errors -> [headers | [errors | result]]
    end
  end

  defp compare(h, first, second) do
    if first.http_headers[h] != second.http_headers[h] do
      [:different, cap_header(h), first.http_headers[h] || "N/A", second.http_headers[h] || "N/A"]
    else
      [:similar, cap_header(h), first.http_headers[h] || "N/A", second.http_headers[h] || "N/A"]
    end
  end

  defp make_headers(%Snapshot{} = s2, proxies) do
    proxy =
      Enum.find(proxies, fn p ->
        p.id == s2.proxy_id
      end)

    [:similar, "headers", "Direct", proxy.name]
  end

  defp maybe_errors(nil, nil), do: nil

  defp maybe_errors(nil, error) do
    [:different, "", "", error]
  end

  defp maybe_errors(error, nil) do
    [:different, "", error, ""]
  end

  defp maybe_errors(err1, err2) do
    [:different, "", err1, err2]
  end

  defp extract_headers(first, second) do
    original_keys =
      first
      |> Map.keys()

    other_keys =
      second
      |> Map.keys()
      |> Enum.reject(&Enum.member?(original_keys, &1))

    original_keys ++ other_keys
  end

  defp cap_header(header) do
    header
    |> String.split("-")
    |> Enum.map(&String.capitalize(&1))
    |> Enum.join("-")
  end
end
