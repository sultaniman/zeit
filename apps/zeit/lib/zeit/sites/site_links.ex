defmodule Zeit.Sites.SiteLinks do
  @moduledoc false
  use Zeit.Model

  schema "site_links" do
    field :site_id, :binary
    field :links, {:array, :string}
  end

  @doc false
  def changeset(attrs) do
    fields = [:site_id, :links]

    %SiteLinks{}
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
