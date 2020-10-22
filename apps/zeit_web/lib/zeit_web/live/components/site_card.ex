defmodule ZeitWeb.Components.SiteCard do
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="site-card zi-card" id="site-<%= @site.id %>">
      <h4 class="site-card__title">
        <%= live_redirect domain(@site.address), to: Routes.site_show_path(@socket, :show, @site) %>

        <%= if @site.is_archive do %>
        <span aria-label="Archive mode" data-balloon-pos="up" class="float-right">
          <img class="site-mode" src="<%= Routes.static_path(@socket, "/images/icons/package-white.svg") %>"/>
        </span>
        <% else %>
        <span aria-label="Monitor mode" data-balloon-pos="up" class="float-right">
          <img class="site-mode" src="<%= Routes.static_path(@socket, "/images/icons/activity-white.svg") %>"/>
        </span>
        <% end %>
      </h4>

      <div class="site-card__stat">
        <p>
          <span><big><%= @links_count %></big> <small>links</small></span>
        </p>
        <p>
          <span><big><%= @used_space %>, <%= @snapshots_count %></big> <small>snapshots</small></span>
        </p>
      </div>

      <div class="site-card__controls">
        <span aria-label="Add links" data-balloon-pos="down" class="site-card__delete">
          <%= live_patch to: Routes.site_index_path(@socket, :add_links, @site) do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/plus-white.svg") %>"/>
          <% end %>
        </span>
        <span class="site-card__edit">
          <%= live_patch to: Routes.site_index_path(@socket, :edit, @site) do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/edit-white.svg") %>"/>
          <% end %>
        </span>
        <span class="site-card__delete">
          <%= link to: "#", phx_click: "delete", phx_value_id: @site.id, data: [confirm: "Are you sure?"] do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/trash-white.svg") %>"/>
          <% end %>
        </span>
      </div>
    </div>
    """
  end
end
