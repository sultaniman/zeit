defmodule Zeit.Schema do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      alias Ecto.Changeset
      import Ecto.Query, warn: false

      alias Zeit.{
        Events,
        Links,
        Lookups,
        Proxies,
        Repo,
        Sites,
        Snapshots,
        Users
      }

      alias Zeit.Events.Event
      alias Zeit.Links.Link
      alias Zeit.Lookups.Lookup
      alias Zeit.Proxies.Proxy
      alias Zeit.Sites.Site
      alias Zeit.Sites.SiteProxy
      alias Zeit.Snapshots.Snapshot
      alias Zeit.Users.User
    end
  end
end
