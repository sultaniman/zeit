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
      <%= for item <- @slice do %>
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

  defp format_timestamp(nil), do: ""
  defp format_timestamp(timestamp) do
    timestamp
    |> DateTime.from_unix!()
    |> Timex.format!("%Y, %B %d %H:%M", :strftime)
  end
end
