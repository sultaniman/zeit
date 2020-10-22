defmodule ZeitWeb.SiteLive.Show do
  @moduledoc false
  use ZeitWeb, :live_view
  alias Size
  alias ZeitWeb.Statuses
  alias Zeit.{
    Links,
    Proxies,
    Sites,
    Snapshots,
  }

  @impl true
  def mount(_params, %{"user" => user} = _session, socket) do
    {
      :ok,
      socket
      |> assign(:user, user)
      |> assign(:page, 1)
      |> assign(:proxies, Proxies.list())
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    site = Sites.get!(id)
    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:site, site)
      |> assign(:links, Sites.links(site))
    }
  end

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

  defp page_title(:show), do: "Show Site"
  defp page_title(:edit), do: "Edit Site"
  defp page_title(:add_links), do: "Add Links"
end
