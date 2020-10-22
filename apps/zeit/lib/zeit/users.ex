defmodule Zeit.Users do
  @moduledoc false
  use Zeit.Schema

  def list do
    Repo.all(User)
  end

  def get!(id), do: Repo.get!(User, id)

  def get_or_create(%{email: email} = params) do
    case Repo.get_by(User, email: email) do
      nil -> create(params)
      user -> {:ok, user}
    end
  end

  def create(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete(%User{} = user) do
    Repo.delete(user)
  end

  def change(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
