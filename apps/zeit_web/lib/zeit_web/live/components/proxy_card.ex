defmodule ZeitWeb.Components.ProxyCard do
  @moduledoc false
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="proxy card zi-card" id="card-<%= @proxy.id %>">
      <h4 class="card__title"><%= @proxy.name %></h4>

      <div class="card__stat proxy__stat">
        <span><%= @snapshots_count %> snapshots</span>
        <span><%= @used_space %></span>
      </div>

      <div class="proxy__address">
        <%= if @user.is_admin do %>
          <%= @proxy.address %>
        <% else %>
          <%= String.duplicate("#", length(@proxy.address)) %>
        <% end %>
      </div>

      <%= if @user.is_admin do %>
      <div class="card__controls">
        <span class="card__edit">
          <%= live_patch to: Routes.proxy_index_path(@socket, :edit, @proxy) do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/edit-white.svg") %>"/>
          <% end %>
        </span>
        <span class="card__delete">
          <%= link to: "#", phx_click: "delete", phx_value_id: @proxy.id, data: [confirm: "Are you sure?"] do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/trash-white.svg") %>"/>
          <% end %>
        </span>
      </div>
      <% end %>
    </div>
    """
  end
end
