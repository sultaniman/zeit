defmodule Zeit.Snapshots do
  @moduledoc false
  use Zeit.Schema
  alias Ecto.Multi

  def list do
    Repo.all(Snapshot)
  end

  def get!(id), do: Repo.get!(Snapshot, id)

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
