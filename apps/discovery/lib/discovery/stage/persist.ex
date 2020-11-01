defmodule Discovery.Persist do
  @moduledoc false
  alias Zeit.Snapshots
  alias Discovery.{Box, Result}

  def run(results) do
    results
    |> Enum.map(&upload/1)
    |> Enum.map(&to_snapshot/1)
    |> Snapshots.create_many()
  end

  defp upload(%Result{} = result) do
    with uploader <- Application.get_env(:discovery, :uploader) do
      filename = make_filename(result.box)
      uploader.upload(filename, create_archive(result))
      %Result{result | snapshot_path: filename}
    end
  end

  defp create_archive(result) do
    result
    |> to_artifact()
    |> Jason.encode!()
    |> :zlib.compress()
  end

  @doc """
  Generates storage path
  * For direct requests       - "site=ae/link=ba/ts=123/direct.gz"
  * For requests with proxies - "site=ae/link=ba/ts=123/proxy=ee.gz"
  """
  def make_filename(%Box{link: link} = box) do
    base_path =
      to_string([
        "site=",
        to_string(link.site_id),
        "/link=",
        to_string(link.id),
        "/ts=",
        to_string(box.timestamp)
      ])

    if box.proxy do
      to_string([base_path, "/proxy=", to_string(box.proxy.id), ".gz"])
    else
      to_string([base_path, "/direct.gz"])
    end
  end

  defp to_snapshot(%Result{} = result) do
    {:ok, moment} = Ecto.Type.cast(:utc_datetime_usec, DateTime.utc_now())

    snapshot = %{
      size: 0,
      path: result.snapshot_path,
      http_status: nil,
      http_headers: %{},
      # to convert to float we divide by 1
      request_duration: result.duration / 1,
      error: result.error,
      timestamp: result.box.timestamp,
      link_id: result.box.link.id,
      site_id: result.box.link.site_id,
      proxy_id: proxy_id(result.box.proxy),
      inserted_at: moment
    }

    if result.response do
      %{
        snapshot
        | size: byte_size(result.response.body),
          http_status: result.response.status_code,
          http_headers: Enum.into(result.response.headers, %{})
      }
    else
      snapshot
    end
  end

  defp to_artifact(%Result{box: box} = result) do
    artifact = %{
      snapshot_path: result.snapshot_path,
      error: result.error,
      duration: result.duration,
      box: %{
        timestamp: box.timestamp,
        link: %{
          address: box.link.address,
          site_id: box.link.site_id
        },
        proxy: get_proxy(box.proxy)
      },
      response: nil
    }

    if result.response do
      %{
        artifact
        | response: %{
            body: result.response.body,
            headers: result.response.headers,
            status: result.response.status_code
          }
      }
    else
      artifact
    end
  end

  defp proxy_id(nil), do: nil
  defp proxy_id(proxy), do: proxy.id

  defp get_proxy(nil), do: nil

  defp get_proxy(proxy) do
    %{
      id: proxy.id,
      name: proxy.name
    }
  end
end
