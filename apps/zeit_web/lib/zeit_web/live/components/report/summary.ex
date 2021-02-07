defmodule ZeitWeb.Components.Summary do
  @moduledoc false
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="summary">
      <span class="summary__date" title="Snapshot date">
      <%= format_timestamp(@timestamp) %>
      </span>
      <div class="summary__snapshots" data-timestamp="<%= @timestamp %>">
      <%= for item <- prepare_snapshots(@slice, @proxies |> Map.keys()) do %>
        <div class="summary__box" data-id="<%= item.id %>" data-link-id="<%= item.link_id %>" >
          <%= live_component @socket,
            ZeitWeb.Components.Banner,
            snapshot: item,
            site: @site,
            route_fn: @route_fn,
            proxies: @proxies %>
        </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp prepare_snapshots(slice, proxy_keys) do
    [
      Enum.find(slice, fn s ->
        is_nil(s.proxy_id)
      end)
      | Enum.map(proxy_keys, fn k ->
          Enum.find(slice, fn s -> s.proxy_id == k end)
        end)
    ]
  end

  defp format_timestamp(nil), do: ""

  defp format_timestamp(timestamp) do
    timestamp
    |> DateTime.from_unix!()
    |> Timex.format!("%Y, %B %d %H:%M", :strftime)
  end
end
