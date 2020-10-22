defmodule Zeit.Events.Event do
  @moduledoc false
  use Zeit.Model

  schema "events" do
    field :type, :string
    field :ref, Ecto.UUID
    field :owner, :string
    field :data, :map

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(proxy, attrs) do
    proxy
    |> cast(attrs, [:type, :ref, :owner, :data])
    |> validate_required([:type, :ref, :owner])
  end
end
