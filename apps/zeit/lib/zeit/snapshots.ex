defmodule Zeit.Snapshots do
  @moduledoc false
  use Zeit.Schema
  alias Zeit.Report
  alias Ecto.Multi

  def per_page, do: 100

  def list do
    Repo.all(Snapshot)
  end

  def get!(id), do: Repo.get!(Snapshot, id)

  def average_request_duration(link_id) do
    Repo.one(
      from s in Snapshot,
        where: s.link_id == ^link_id,
        select: avg(s.request_duration)
    )
  end

  def total_size(link_id) do
    size =
      Repo.one(
        from s in Snapshot,
          where: s.link_id == ^link_id,
          select: sum(s.size)
      )

    alternative_symbols = ~w(bytes Kb Mb Gb Tb Pb)

    Size.humanize!(
      size || 0,
      output: :string,
      round: 1,
      symbols: alternative_symbols
    )
  end

  def snapshot_for(link_id, page) do
    all_timestamps(link_id, page)
  end

  # Historical
  def all_timestamps(link_id, page) do
    qty = per_page()

    {
      Repo.one(
        from s in Snapshot,
          select: count(s.timestamp, :distinct),
          where: s.link_id == ^link_id
      ),
      Repo.all(
        from s in Snapshot,
          select: s.timestamp,
          where: s.link_id == ^link_id,
          distinct: true,
          order_by: [desc: s.timestamp],
          offset: ^((page - 1) * qty),
          limit: ^qty
      )
    }
  end

  # Reports
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
