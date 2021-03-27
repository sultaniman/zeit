defmodule ZeitWeb.Components.SiteItem do
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="site-item zi-note" id="site-<%= @site.id %>">
      <div>
        <%= if @site.is_archive do %>
        <span class="site-item__mode" aria-label="Archive mode" data-balloon-pos="up">
          <img class="site-mode" src="<%= Routes.static_path(@socket, "/images/icons/package-white.svg") %>"/>
        </span>
        <% else %>
        <span class="site-item__mode" aria-label="Monitor mode" data-balloon-pos="up">
          <img class="site-mode" src="<%= Routes.static_path(@socket, "/images/icons/activity-white.svg") %>"/>
        </span>
        <% end %>
        <%= live_redirect domain(@site.address), to: Routes.site_show_path(@socket, :show, @site) %>
      </div>

      <div class="site-item__stats">
        <span><%= @links_count %> links</span> /
        <span><%= @used_space %> / <%= @snapshots_count %> snapshots</span>
      </div>

      <div class="site-item__actions">
        <span aria-label="Add links" data-balloon-pos="down">
          <%= live_patch to: Routes.site_index_path(@socket, :add_links, @site) do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/plus-white.svg") %>"/>
          <% end %>
        </span>
        <span>
          <%= live_patch to: Routes.site_index_path(@socket, :edit, @site) do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/edit-white.svg") %>"/>
          <% end %>
        </span>
        <span>
          <%= link to: "#", phx_click: "delete", phx_value_id: @site.id, data: [confirm: "Are you sure?"] do %>
            <img src="<%= Routes.static_path(@socket, "/images/icons/trash-white.svg") %>"/>
          <% end %>
        </span>
      </div>
    </div>
    """
  end
end
