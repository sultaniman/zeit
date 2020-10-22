defmodule Zeit.Proxies do
  @moduledoc false
  use Zeit.Schema

  def list do
    Repo.all(Proxy)
  end

  def get!(id), do: Repo.get!(Proxy, id)

  def create(attrs \\ %{}) do
    %Proxy{}
    |> Proxy.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Proxy{} = proxy, attrs) do
    proxy
    |> Proxy.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Proxy{} = proxy) do
    Repo.delete(proxy)
  end

  def change(%Proxy{} = proxy, attrs \\ %{}) do
    Proxy.changeset(proxy, attrs)
  end


  def snapshots_count(proxy) do
    Repo.one(
      from s in Snapshot,
      select: count(s.id),
      where: s.proxy_id == ^proxy.id
    )
  end

  def used_space(proxy) do
    alternative_symbols = ~w(bytes Kb Mb Gb Tb Pb)
    size = Repo.one(
      from s in Snapshot,
      select: sum(s.size),
      where: s.proxy_id == ^proxy.id
    )

    Size.humanize!(
      size || 0,
      output: :string,
      round: 1,
      symbols: alternative_symbols
    )
  end
end
