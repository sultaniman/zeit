defmodule Zeit.Sites do
  @moduledoc false
  use Zeit.Schema
  alias Ecto.Multi
  alias Size
  alias Zeit.Validators.ValidateLinks

  def list do
    Repo.all(Site)
  end

  def get_by_user(user) do
    Repo.all(
      from s in Site,
      where: s.user_id == ^user.id
    )
  end

  def get!(id), do: Repo.get!(Site, id)

  def create(attrs \\ %{}) do
    %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()
  end

  def create_many({moment, user_id, sites}) do
    result =
      Multi.new()
      |> Multi.insert_all(:sites, Site, sites)
      |> Repo.transaction()

    from_moment = Timex.Duration.from_seconds(5)
    moment = Timex.subtract(moment, from_moment)
    created_sites =
      from s in Site,
        where: s.user_id == ^user_id and s.inserted_at >= ^moment

    created_sites
    |> Repo.all()
    |> Enum.map(fn site ->
      %{
        address: site.address,
        site_id: site.id,
        inserted_at: moment,
        updated_at: moment
      }
    end)
    |> Links.create_many()

    result
  end

  def update(%Site{} = site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Site{} = site) do
    Repo.delete(site)
  end

  def prepare_many(addresses, user_id, enforce_https \\ true) do
    {:ok, moment} = Ecto.Type.cast(:utc_datetime_usec, DateTime.utc_now())

    {
      moment,
      user_id,
      addresses
      |> Enum.map(&normalize(&1, enforce_https))
      |> Enum.uniq()
      |> Enum.filter(&ValidateLinks.valid_link?/1)
      |> Enum.map(fn site ->
        %{
          address: site,
          is_archive: false,
          user_id: user_id,
          inserted_at: moment,
          updated_at: moment
        }
      end)
    }
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

    size =
      Repo.one(
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

  def stream(chunk_size) do
    Repo.flow_stream(Site, chunk_size: chunk_size)
  end

  def stream_links(site, chunk_size) do
    query =
      from l in Link,
        where: l.site_id == ^site.id

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

  # Utils
  @doc """
  Normalizes the given link, resets port to `nil`,
  second argument means to enforce `https` if set
  """
  def normalize(link, true) do
    link
    |> prepend_protocol("https")
    |> get_uri()
    |> URI.to_string()
  end

  def normalize(link, false) do
    link
    |> prepend_protocol("http")
    |> get_uri()
    |> URI.to_string()
  end

  defp prepend_protocol(link, default_protocol) do
    if String.contains?(link, "://") do
      [_, rest] = String.split(link, "://")
      "#{default_protocol}://#{rest}"
    else
      "#{default_protocol}://#{link}"
    end
  end

  defp get_uri(link) do
    case URI.parse(link) do
      %URI{scheme: nil} = uri -> %URI{uri | scheme: "http", port: nil}
      uri -> %URI{uri | port: nil}
    end
  end
end
