defmodule Discovery.Request do
  @moduledoc false
  alias Discovery.Fetch

  # 3 minutes
  @default_timeout 60_000 * 3

  def run(boxes) do
    boxes
    |> Enum.map(&async_fetch/1)
    |> Task.await_many(timeout())
  end

  defp async_fetch(box) do
    Task.async(fn ->
      Fetch.fetch(box)
    end)
  end

  defp timeout do
    Application.get_env(:discovery, :max_timeout, @default_timeout)
  end
end
