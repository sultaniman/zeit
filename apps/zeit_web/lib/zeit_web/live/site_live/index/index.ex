defmodule ZeitWeb.SiteLive.Index do
  use ZeitWeb, :live_view

  alias Zeit.Sites
  alias Zeit.Sites.Site
  alias Zeit.Sites.SiteLinks
  alias ZeitWeb.Strings

  @impl true
  def mount(_params, %{"user" => user} = _session, socket) do
    {
      :ok,
      socket
      |> assign(:sites, Sites.list())
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

  defp apply_action(socket, :add_links, %{"id" => id}) do
    socket
    |> assign(:page_title, "Listing Sites")
    |> assign(:site, Sites.get!(id))
    |> assign(:site_links, SiteLinks.changeset(%{site_id: id, links: []}))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site = Sites.get!(id)
    {:ok, _} = Sites.delete(site)

    {:noreply, assign(socket, :sites, Sites.list())}
  end
end
