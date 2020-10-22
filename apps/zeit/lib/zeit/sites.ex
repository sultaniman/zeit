defmodule Zeit.Sites do
  @moduledoc false
  use Zeit.Schema
  alias Size

  def list do
    Repo.all(Site)
  end

  def get!(id), do: Repo.get!(Site, id)

  def create(attrs \\ %{}) do
    %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Site{} = site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Site{} = site) do
    Repo.delete(site)
  end

  def links_count(site) do
    Repo.one(
      from l in Link,
      select: count(l.id),
      where: l.site_id == ^site.id
    )
  end

  def snapshots_count(site) do
    Repo.one(
      from s in Snapshot,
      select: count(s.id),
      where: s.site_id == ^site.id
    )
  end

  def used_space(site) do
    alternative_symbols = ~w(bytes Kb Mb Gb Tb Pb)
    size = Repo.one(
      from s in Snapshot,
      select: sum(s.size),
      where: s.site_id == ^site.id
    )

    Size.humanize!(
      size || 0,
      output: :string,
      round: 1,
      symbols: alternative_symbols
    )
  end

  def links(site) do
    Repo.all(
      from l in Link,
      where: l.site_id == ^site.id
    )
  end

  def stream_links(site, chunk_size) do
    query = (
      from l in Link,
      where: l.site_id == ^site.id
    )

    Repo.flow_stream(query, chunk_size: chunk_size)
  end

  def change(%Site{} = site, attrs \\ %{}) do
    Site.changeset(site, attrs)
  end

  # Proxy routines
  def add_proxy(site_id, proxy_id) do
    %SiteProxy{}
    |> SiteProxy.changeset(%{site_id: site_id, proxy_id: proxy_id})
    |> Repo.insert()
  end
end
