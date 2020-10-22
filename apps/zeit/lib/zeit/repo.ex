defmodule Zeit.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :zeit,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query
  require Logger

  def init(_type, config) do
    database_url = System.get_env("DATABASE_URL")
    if database_url == nil do
      Logger.debug("$DATABASE_URL not set, using config")
      {:ok, config}
    else
      Logger.debug("Configuring database using $DATABASE_URL")
      {:ok, Keyword.put(config, :url, database_url)}
    end
  end

  @doc """
  Stream query results
  Example:

    iex> Link
    ...> |> Repo.flow_stream(chunk_size: 500)
  """
  def flow_stream(query, opts \\ []) do
    chunk_size = Keyword.get(opts, :chunk_size, 1000)

    Stream.resource(
      # start with initial offset=0
      fn -> {query, 0} end,

      # get at most `chunk_size` items
      fn {query, last_offset} ->
        list =
          query
          |> offset(^last_offset)
          |> limit(^(chunk_size - 1))
          |> all()

        case List.last(list) do
          nil -> {:halt, {query, last_offset}}
          _entity -> {list, {query, last_offset + chunk_size}}
        end
      end,
      fn _ -> [] end
    )
  end
end
