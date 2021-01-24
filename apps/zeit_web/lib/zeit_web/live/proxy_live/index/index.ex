defmodule ZeitWeb.ProxyLive.Index do
  use ZeitWeb, :live_view
  alias Zeit.Proxies
  alias Zeit.Proxies.Proxy

  @impl true
  def mount(_params, %{"user" => user} = _session, socket) do
    {
      :ok,
      socket
      |> assign(:proxies, Proxies.list())
      |> assign(:user, user)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Proxy")
    |> assign(:proxy, Proxies.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Proxy")
    |> assign(:proxy, %Proxy{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Proxies")
    |> assign(:proxy, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    proxy = Proxies.get!(id)
    {:ok, _} = Proxies.delete(proxy)

    {:noreply, assign(socket, :proxies, Proxies.list())}
  end
end
