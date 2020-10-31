defmodule Zeit.Sites.SiteList do
  @moduledoc false
  use Zeit.Model

  schema "site_list" do
    field :sites, :string
    field :enforce_https, :boolean
  end

  @doc false
  def changeset(attrs) do
    %SiteList{}
    |> cast(attrs, [:sites, :enforce_https])
    |> validate_required([:sites, :enforce_https])
  end
end
