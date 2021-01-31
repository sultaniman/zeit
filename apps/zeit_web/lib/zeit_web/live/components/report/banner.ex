defmodule ZeitWeb.Components.Banner do
  @moduledoc false
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="banner">
      <span>
      <%= if is_nil(@snapshot.proxy_id) do %>
      <span aria-label="Direct" data-balloon-pos="left">
      <img src="<%= Routes.static_path(@socket, "/images/icons/direct.svg") %>"/>
      </span>
      <% else %>
      <span class="banner__route" aria-label="Via proxy" data-balloon-pos="left">
        <%= @proxies |> get_proxy_name(@snapshot.proxy_id) %>
        <img src="<%= Routes.static_path(@socket, "/images/icons/proxy.svg") %>"/>
      </span>
      <% end %>
      <span class="zi-badge <%= Statuses.format_class(@snapshot.http_status) %>">
        <%= @snapshot.http_status %>
      </span>
      <%= format_bytes(@snapshot.size) %> /
      <%= @snapshot.request_duration/1000 %>s
      <%= if !is_nil(@snapshot.error) do %> /
      <%= Strings.get_error(@snapshot.error) %>
      <% end %>
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
