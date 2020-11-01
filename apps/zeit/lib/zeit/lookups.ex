defmodule Zeit.Lookups do
  @moduledoc false
  use Zeit.Schema

  def all, do: Repo.all(Lookup)

  @doc """
  Create site with the following input parameters
    ```ex
    %{
      inet_address: "127.0.0.1",
      site_id: <UUID>
    }
    ```
  """
  def create_lookup(params) do
    %Lookup{}
    |> Lookup.create(params)
    |> Repo.insert()
  end

  def find_by_site(site) do
    query =
      from(
        l in Lookup,
        where: l.site_id == ^site.id,
        order_by: [desc: l.inserted_at]
      )

    Repo.all(query)
  end

  def latest_for_site(site) do
    query =
      from(
        l in Lookup,
        where: l.site_id == ^site.id,
        order_by: [desc: l.inserted_at],
        limit: 1
      )

    case Repo.one(query) do
      nil -> nil
      lookup -> lookup
    end
  end

  def delete_by_site(site) do
    query = from l in Lookup, where: l.site_id == ^site.id
    Repo.delete_all(query)
  end
end
