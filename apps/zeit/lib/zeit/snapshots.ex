defmodule Zeit.Snapshots do
  @moduledoc false
  use Zeit.Schema
  alias Zeit.Report
  alias Ecto.Multi

  def list do
    Repo.all(Snapshot)
  end

  def get!(id), do: Repo.get!(Snapshot, id)

  def snapshots_at(timestamp, link_id) do
    Repo.all(
      from s in Snapshot,
        where: [link_id: ^link_id, timestamp: ^timestamp]
    )
  end

  def latest_moment(%Site{} = site) do
    latest_index =
      Repo.one(
        from snapshot in Snapshot,
          join: l in Link,
          on: l.address == ^site.address and l.id == snapshot.link_id,
          select: %{timestamp: snapshot.timestamp, link_id: l.id},
          order_by: [desc: snapshot.timestamp],
          limit: 1
      )

    if latest_index do
      latest_index
    else
      nil
    end
  end

  def report_latest(%Site{} = site) do
    case latest_moment(site) do
      nil ->
        nil

      %{timestamp: ts, link_id: lid} ->
        %Report{
          site: site,
          snapshots:
            Repo.all(
              from s in Snapshot,
                where:
                  s.link_id == ^lid and s.timestamp == ^ts and
                    (s.http_status >= 400 or is_nil(s.http_status))
            )
        }
    end
  end

  def create(attrs \\ %{}) do
    %Snapshot{}
    |> Snapshot.changeset(attrs)
    |> Repo.insert()
  end

  def create_many(snapshots) do
    Multi.new()
    |> Multi.insert_all(:snapshots, Snapshot, snapshots)
    |> Repo.transaction()
  end

  def delete(%Snapshot{} = snapshot) do
    Repo.delete(snapshot)
  end
end
