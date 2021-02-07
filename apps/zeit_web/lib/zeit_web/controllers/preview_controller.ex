defmodule ZeitWeb.PreviewController do
  use ZeitWeb, :controller
  alias Discovery.S3Storage
  alias Zeit.Snapshots

  def index(conn, %{"snapshot_id" => snapshot_id}) do
    snapshot = Snapshots.get!(snapshot_id)

    case S3Storage.get(snapshot.path) do
      {:ok, response} ->
        body =
          response.body
          |> :zlib.uncompress()
          |> Jason.decode!()
          |> get_in(["response", "body"])
          |> Base.decode64!()

        html(conn, body)

      error ->
        html(conn, "Oops, something went wrong #{error}")
    end
  end
end
