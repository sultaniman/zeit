defmodule ZeitWeb.Components.LinkItem do
  @moduledoc false
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="link">
      <%= @link.address %>

      <%= link to: "#", phx_click: "delete_link", phx_value_id: @link.id do %>
        <img src="<%= Routes.static_path(@socket, "/images/icons/trash-white.svg") %>"/>
      <% end %>
    </div>
    """
  end
end
