defmodule ZeitWeb.SiteLive.Index do
  use ZeitWeb, :live_view

  alias Zeit.{Events, Sites}
  alias Zeit.Sites.{
    Site,
    SiteLinks,
    SiteList
  }

  alias ZeitWeb.Strings

  @impl true
  def mount(_params, %{"user" => user} = _session, socket) do
    {
      :ok,
      socket
      |> assign(:sites, Sites.get_by_user(user))
      |> assign(:user, user)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Site")
    |> assign(:site, Sites.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site")
    |> assign(:site, %Site{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sites")
    |> assign(:site, nil)
  end

  defp apply_action(socket, :import_sites, _params) do
    socket
    |> assign(:page_title, "Import Sites")
    |> assign(:site_list, SiteList.changeset(%{enforce_https: true, sites: ""}))
  end

  defp apply_action(socket, :add_links, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add Links")
    |> assign(:site, Sites.get!(id))
    |> assign(:site_links, SiteLinks.changeset(%{site_id: id, links: []}))
  end

  defp apply_action(socket, :diff, %{"id" => id}) do
    socket
    |> assign(:page_title, "Diff Site")
    |> assign(:site, Sites.get!(id))
    |> assign(:site_links, SiteLinks.changeset(%{site_id: id, links: []}))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site = Sites.get!(id)
    {:ok, _} = Sites.delete(site)
    Events.create(%{
      type: "site:delete",
      ref: site.id,
      owner: socket.assigns.user.id,
      data: %{
        address: site.address,
        is_archive: site.is_archive
      }
    })

    {:noreply, assign(socket, :sites, Sites.list())}
  end
end
