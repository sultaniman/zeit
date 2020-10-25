defmodule ZeitWeb.SiteLive.Show do
  @moduledoc false
  use ZeitWeb, :live_view

  alias ZeitWeb.Statuses

  alias Zeit.{
    Links,
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
      |> assign(:proxies, Proxies.list())
      |> assign(:action, nil)
    }
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

  defp apply_action(socket, :diff, %{"link_id" => link_id, "timestamp" => timestamp}) do
    snapshots = Snapshots.snapshots_at(timestamp, link_id)

    socket
    |> assign(:link, Links.get!(link_id))
    |> assign(:direct, Enum.find(snapshots, &is_nil(&1.proxy_id)))
    |> assign(:over_proxy, Enum.reject(snapshots, &is_nil(&1.proxy_id)))
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
end
