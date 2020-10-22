defmodule Zeit.Users.User do
  @moduledoc false
  use Zeit.Model

  schema "users" do
    field :email, :string
    field :full_name, :string
    field :provider, :string
    field :is_admin, :boolean

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    fields = [:email, :full_name, :provider, :is_admin]

    user
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
