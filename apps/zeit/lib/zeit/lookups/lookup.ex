defmodule Zeit.Lookups.Lookup do
  @moduledoc false
  use Zeit.Model
  alias Zeit.Sites.Site

  schema "lookups" do
    field :inet_address, :string
    belongs_to :site, Site

    timestamps()
  end

  @doc false
  def changeset(%Lookup{} = lookup, attrs) do
    # Since IP address comes from name lookup
    # we are intentionally omitting validation
    fields = [:inet_address, :site_id]

    lookup
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> foreign_key_constraint(:site_id)
  end

  def create(%Lookup{} = lookup, params), do: lookup |> changeset(params)
  def update(%Lookup{} = lookup, params), do: lookup |> changeset(params)
end
