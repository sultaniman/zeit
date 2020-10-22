defmodule Zeit.Events do
  @moduledoc false
  use Zeit.Schema

  def list do
    Repo.all(Event)
  end

  def get!(id), do: Repo.get!(Event, id)

  def create(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def delete(%Event{} = event) do
    Repo.delete(event)
  end
end
