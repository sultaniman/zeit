defmodule ZeitWeb.Components.Banner do
  @moduledoc false
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="banner">
      <span>
        <span class="zi-badge <%= Statuses.format_class(@snapshot.http_status) %>">
          <%= @snapshot.http_status %>
        </span>
        <%= format_bytes(@snapshot.size) %> /
        <%= @snapshot.request_duration/1000 %>s
        <%= if !is_nil(@snapshot.error) do %> /
        <%= Strings.get_error(@snapshot.error) %>
        <% end %>

        <div class="banner__actions">
          <%= link to: Routes.link_index_path(@socket, :preview, @snapshot.link_id, @snapshot.id), class: "nav-link", title: "Preview page" do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/eye.svg") %>"/>
          <% end %>

          <%= if @snapshot.proxy_id do %>
            <%= live_patch to: @route_fn.(@socket, @snapshot), class: "banner__diff", title: "View diff" do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/diff.svg") %>"/>
            <% end %>
            <span class="banner__route">
              proxy: <%= @proxies |> get_proxy_name(@snapshot.proxy_id) %>
            </span>
          <% else %>
            <span class="banner__route">
              direct
            </span>
          <% end %>
        </div>
      </span>
    </div>
    """
  end

  defp get_proxy_name(proxies, proxy_id) do
    proxies
    |> Map.get(proxy_id)
    |> Map.get(:name)
  end
end
