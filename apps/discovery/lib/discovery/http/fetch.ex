defmodule Discovery.Fetch do
  @moduledoc false
  require Logger
  use Retry
  alias Discovery.{Box, Result, Helpers}

  @max_redirects 2
  @wait_before_retry 1_000
  @max_retries 3
  @redirect_statuses [301, 302, 303, 307, 308]

  def fetch(%Box{} = box) do
    start_ms = System.monotonic_time(:millisecond)

    result =
      retry with: constant_backoff(@wait_before_retry) |> Stream.take(@max_retries) do
        get(box.link.address, [], box.config, 0)
      after
        {:ok, result} -> result
      else
        {:error, result} -> result
      end

    %Result{
      result
      | box: box,
        duration: Helpers.duration(start_ms)
    }
  end

  def get(link, headers, options, num_redirects) do
    case HTTPoison.get(link, headers, options) do
      {:ok, %HTTPoison.Response{} = response} ->
        if Enum.member?(@redirect_statuses, response.status_code) do
          num_redirects = num_redirects + 1

          if num_redirects <= @max_redirects do
            next = get_location(response.headers)

            Logger.notice(["Following redirect #", Integer.to_string(num_redirects), " to ", next])

            get(next, headers, options, num_redirects)
          else
            {:error, %Result{error: "exceeded maximum redirects"}}
          end
        else
          {:ok, %Result{response: response}}
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %Result{error: Jason.encode!(reason)}}
    end
  end

  defp get_location(headers) do
    {_h, location} =
      Enum.find(headers, fn {header, _location} ->
        String.downcase(header) == "location"
      end)

    location
  end
end
