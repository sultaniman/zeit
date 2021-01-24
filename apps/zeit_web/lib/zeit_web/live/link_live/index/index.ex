defmodule ZeitWeb.LinkLive.Index do
  @moduledoc """
  This view allows to see snapshots for given link and only provides
  the following capabilities

    1. View diffs,
    2. Delete snapshot including results over proxies
  """
  use ZeitWeb, :live_view
  alias Zeit.Links
  alias Zeit.Links.Link

  @impl true
  def mount(%{"id" => id}, %{"user" => user} = _session, socket) do
    link = Links.get!(id)

    {
      :ok,
      socket
      |> assign(:user, user)
      |> assign(:id, id)
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   link = Links.get!(id)
  #   {:ok, _} = Link.delete(link)

  #   {:noreply, assign(socket, :proxies, Proxies.list())}
  # end
end
