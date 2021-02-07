defmodule ZeitWeb.LinkLive.Index do
  @moduledoc """
  This view allows to see snapshots for given link and only provides
  the following capabilities

    1. View diffs,
    2. Delete snapshot including results over proxies
  """
  use ZeitWeb, :live_view
  alias Zeit.{Links, Proxies, Sites, Snapshots}

  @impl true
  def mount(%{"id" => id} = params, %{"user" => user} = _session, socket) do
    link = Links.get!(id)
    page = params |> Map.get("page", "1") |> get_page()

    {count, ts} = Snapshots.all_timestamps(id, page)

    {
      :ok,
      socket
      |> assign(:user, user)
      |> assign(:id, id)
      |> assign(:link, link)
      |> assign(:site, Sites.get!(link.site_id))
      |> assign(:avg_request_duration, id |> Snapshots.average_request_duration() |> format_load_time())
      |> assign(:avg_page_size, id |> Snapshots.average_page_size() |> Strings.humanize_size())
      |> assign(:total_size, Snapshots.total_size(id))
      |> assign(:count, count)
      |> assign(:total_snapshots, Snapshots.count_for_link(id))
      |> assign(:proxies, prepare_proxies())
      |> assign(:timestamps, ts)
      |> assign(:page, page)
      |> assign(:pages, get_num_pages(count, Snapshots.per_page()))
      |> assign(:per_page, Snapshots.per_page())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def diff_link(socket, snapshot) do
    direct = Snapshots.direct_snapshot(snapshot.link_id, snapshot.timestamp)
    Routes.link_index_path(socket, :diff, snapshot.link_id, direct.id, snapshot.id)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Snapshot history")
  end

  defp apply_action(socket, :diff, %{"first" => first, "second" => second}) do
    socket
    |> assign(:first, Snapshots.get!(first))
    |> assign(:second, Snapshots.get!(second))
    |> assign(:page_title, "View diff")
  end

  defp apply_action(socket, :preview, %{"snapshot_id" => snapshot_id}) do
    socket
    |> assign(:snapshot, Snapshots.get!(snapshot_id))
    |> assign(:page_title, "Preview page")
  end

  defp apply_action(socket, _, _), do: socket

  defp prepare_proxies do
    Proxies.list()
    |> Enum.map(fn proxy ->
      {proxy.id, proxy}
    end)
    |> Enum.into(%{})
  end

  defp get_page(page) do
    case Integer.parse(page) do
      {p, _} ->
        if p <= 0 do
          1
        else
          p
        end

      :error ->
        1
    end
  end

  defp get_num_pages(count, per_page) do
    pages = div(count, per_page)

    if count <= per_page do
      0
    else
      if rem(count, per_page) > 0 do
        pages + 1
      else
        pages
      end
    end
  end

  defp format_load_time(nil), do: 0
  defp format_load_time(load_time) do
    (load_time / 1000) |> Float.round(2)
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   link = Links.get!(id)
  #   {:ok, _} = Link.delete(link)

  #   {:noreply, assign(socket, :proxies, Proxies.list())}
  # end
end
