defmodule Discovery.S3Storage do
  @moduledoc false
  @bucket Application.get_env(:discovery, :snaphots_path)

  def upload(filename, data) do
    # TODO: retry & backoff feature has to be here
    @bucket
    |> ExAws.S3.put_object(filename, data)
    |> ExAws.request!()
  end

  def get(path) do
    @bucket
    |> ExAws.S3.get_object(path)
    |> ExAws.request()
  end

  def name_only?, do: true
end
