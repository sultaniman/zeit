defmodule Zeit.Validators.ValidateLinks do
  @moduledoc false
  def validate(links, address) do
    %URI{host: host} = URI.parse(address)
    validated =
      links
      |> Enum.map(&validate_link(&1, host))

    {
      validated
      |> Enum.filter(fn x -> elem(x, 0) == :valid end)
      |> Keyword.values(),

      validated
      |> Enum.filter(fn x -> elem(x, 0) == :invalid end)
      |> Keyword.values()
    }
  end

  defp validate_link(link, host) do
    if valid_link?(link) do
      validate_domain(link, host)
    else
      {:invalid, link}
    end
  end

  defp valid_link?(link) do
    if String.trim(link) == "" do
      false
    else
      valid_protocol?(link)
    end
  end

  defp valid_protocol?(url) do
    String.starts_with?(url, "http")
  end

  defp validate_domain(url, host) do
    uri = URI.parse(url)
    if uri.host == host do
      {:valid, url}
    else
      {:invalid, url}
    end
  end
end
