defmodule Zeit.Links.Link do
  use Zeit.Model
  alias Zeit.Sites.Site

  schema "links" do
    field :address, :string
    belongs_to :site, Site

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:address, :site_id])
    |> validate_required([:address, :site_id])
    |> foreign_key_constraint(:site_id)
  end
end
