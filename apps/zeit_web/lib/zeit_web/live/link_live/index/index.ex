defmodule ZeitWeb.LinkLive.Index do
  @moduledoc """
  This view allows to see snapshots for given link and only provides
  the following capabilities

    1. View diffs,
    2. Delete snapshot including results over proxies
  """
  use ZeitWeb, :live_view
  alias Zeit.Links
  alias Zeit.Snapshots

  @impl true
  def mount(%{"id" => id}, %{"user" => user} = _session, socket) do
    link = Links.get!(id)
    {count, ts} = Snapshots.all_timestamps(id, 1)
    {
      :ok,
      socket
      |> assign(:user, user)
      |> assign(:id, id)
      |> assign(:link, link)
      |> assign(:count, count)
      |> assign(:timestamps, ts)
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
