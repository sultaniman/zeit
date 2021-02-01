defmodule ZeitWeb.Components.Pager do
  @moduledoc false
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="pager">
      <%= if @current_page > 1 do %>
      <%= live_redirect to: get_link(@socket, @link.id, @current_page - 1), class: "pager__page" do %>
        Prev
      <% end %>
      <% end %>

      <%# TODO: Implement page tails %>
      <%= for page <- 1..@pages do %>
        <%= live_redirect to: get_link(@socket, @link.id, page), class: get_class(@current_page == page) do %>
        <%= page %>
        <% end %>
      <% end %>

      <%= if @current_page < @pages-1 do %>
      <%= live_redirect to: get_link(@socket, @link.id, @current_page + 1), class: "pager__page" do %>
        Next
        <% end %>
      <% end %>
    </div>
    <style>
    .pager {
      margin: 20px 0;
    }

    .pager__page {
      display: inline-block;
      font-size: 14px;
      padding: 0px 6px 6px 6px;
    }
    .pager__page--active {
      color: #333;
    }
    </style>
    """
  end

  defp get_link(socket, link_id, page) do
    [Routes.link_index_path(socket, :index, link_id), "?page=", Integer.to_string(page)]
  end

  defp get_class(false), do: "pager__page"
  defp get_class(true), do: "pager__page pager__page--active"
end
