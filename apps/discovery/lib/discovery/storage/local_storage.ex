defmodule Discovery.LocalStorage do
  @moduledoc false
  def upload(path, data) do
    ensure_directory(path)

    case File.write(path, data, [:raw, :binary]) do
      :ok -> {:ok, path}
      {:error, reason} -> {:error, reason}
    end
  end

  def name_only?, do: false

  defp ensure_directory(path) do
    unless File.exists?(path) do
      path
      |> Path.dirname()
      |> File.mkdir_p()
    end
  end
end
