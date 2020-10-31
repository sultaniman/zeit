defmodule Zeit.Links do
  @moduledoc false
  use Zeit.Schema
  alias Ecto.Multi

  def list do
    Repo.all(Link)
  end

  def stream(chunk_size) do
    Repo.flow_stream(Link, chunk_size: chunk_size)
  end

  def get!(id), do: Repo.get!(Link, id)

  def create(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  def create_many(links) do
    Multi.new()
    |> Multi.insert_all(:links, Link, links)
    |> Repo.transaction()
  end

  def prepare_many(links, site_id) do
    {:ok, moment} = Ecto.Type.cast(:utc_datetime_usec, DateTime.utc_now())

    Enum.map(links, fn link ->
      %{
        address: link,
        site_id: site_id,
        inserted_at: moment,
        updated_at: moment
      }
    end)
  end

  def update(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns latest snapshots, performs
  2 queries one to get latest timestamp
  second to load all related snapshots
  for given link with that timestamp.
  """
  def latest_snapshots(%Link{} = link) do
    query =
      from s in Snapshot,
        select: [:timestamp],
        where: s.link_id == ^link.id,
        order_by: [desc: :timestamp],
        limit: 1

    case Repo.one(query) do
      nil ->
        []

      %Snapshot{timestamp: timestamp} ->
        Snapshots.snapshots_at(timestamp, link.id)
    end
  end

  def delete(%Link{} = link) do
    Repo.delete(link)
  end

  def change(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end
end
