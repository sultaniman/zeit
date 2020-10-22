defmodule Zeit.Sites.Site do
  @moduledoc false
  use Zeit.Model
  alias Zeit.Users.User

  schema "sites" do
    field :address, :string
    field :is_archive, :boolean, default: false
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:address, :is_archive, :user_id])
    |> validate_required([:address, :is_archive, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
