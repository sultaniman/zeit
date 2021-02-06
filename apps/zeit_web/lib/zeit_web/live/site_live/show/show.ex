defmodule ZeitWeb.SiteLive.Show do
  @moduledoc false
  use ZeitWeb, :live_view

  alias Zeit.{
    Links,
    Lookups,
    Proxies,
    Sites,
    Snapshots
  }

  @impl true
  def mount(_params, %{"user" => user} = _session, socket) do
    {
      :ok,
      socket
      |> assign(:user, user)
      |> assign(:page, 1)
      |> assign(:proxies, prepare_proxies())
      |> assign(:action, nil)
    }
  end

  defp prepare_proxies do
    Proxies.list()
    |> Enum.map(fn proxy ->
      {proxy.id, proxy}
    end)
    |> Enum.into(%{})
  end

  @impl true
  def handle_params(%{"id" => id} = params, _, socket) do
    site = Sites.get!(id)

    {
      :noreply,
      socket
      |> assign(:site, site)
      |> assign(:links, Sites.links(site))
      |> assign(:page_title, Strings.title_text(:site, socket.assigns.live_action))
      |> apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :diff, %{"first" => first, "second" => second}) do
    first = Snapshots.get!(first)
    link = Links.get!(first.link_id)
    socket
    |> assign(:link, link)
    |> assign(:first, first)
    |> assign(:second, Snapshots.get!(second))
  end

  defp apply_action(socket, _, _), do: socket

  @impl true
  def handle_event("delete_link", %{"id" => id}, %{assigns: %{site: site}} = socket) do
    id
    |> Links.get!()
    |> Links.delete()

    {
      :noreply,
      socket
      |> assign(:links, Sites.links(site))
    }
  end

  def diff_link(socket, snapshot) do
    direct = Snapshots.direct_snapshot(snapshot.link_id, snapshot.timestamp)
    Routes.site_show_path(socket, :diff, snapshot.site_id, direct.id, snapshot.id)
  end
end
