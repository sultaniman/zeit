defmodule Zeit.Sites.SiteProxy do
  @moduledoc false
  use Zeit.Model

  alias Zeit.Proxies.Proxy
  alias Zeit.Sites.Site

  schema "sites_proxies" do
    belongs_to :site, Site
    belongs_to :proxy, Proxy
  end

  @doc false
  def changeset(site_proxy, attrs) do
    fields = [:site_id, :proxy_id]

    site_proxy
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> foreign_key_constraint(:site_id)
    |> foreign_key_constraint(:proxy_id)
  end
end
