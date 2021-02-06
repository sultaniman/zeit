defmodule ZeitWeb.Components.Diffy do
  use ZeitWeb, :live_component
  alias ZeitWeb.{Differ, Statuses}

  @impl true
  def render(assigns) do
    ~L"""
    <div class="diff zi-fieldset-content modal__content">
      <h4 class="card__title">
        <%= String.upcase(domain(@link.address)) %>
      </h4>

      <div class="diff__viewer">
      <%= for [mode, header, first, second] <- Differ.calculate_diff(@first, @second, @proxies) do %>
        <div class="<%= mode %> diffs">
          <span class="diffs__header"><%= header %></span>
          <span class="diffs__first"><%= first %></span>
          <span class="diffs__second"><%= second %></span>
        </div>
        <%= if String.downcase(header) == "headers" do %>
        <div class="diffs diffs--report">
          <span class="diffs__header">&nbsp;</span>
          <span class="diffs__first report report--packed">
            <span class="zi-badge <%= snapshot_status_color(@first) %> dot" data-balloon-pos="up">&nbsp;</span>
            <%= format_bytes(@first.size) %> /
            <span aria-label="<%= Statuses.format(@first.http_status) %>" data-balloon-pos="up"><%= @first.http_status %></span> /
            <%= @first.request_duration/1000 %>s
          </span>

          <span class="diffs__second report report--packed">
            <span class="zi-badge <%= snapshot_status_color(@first) %> dot" data-balloon-pos="up">&nbsp;</span>
            <%= format_bytes(@second.size) %> /
            <span aria-label="<%= Statuses.format(@second.http_status) %>" data-balloon-pos="up"><%= @second.http_status %></span> /
            <%= @second.request_duration/1000 %>s
          </span>
        </div>
        <% end %>
      <% end %>
      </div>
    </div>
    <div class="modal__footer zi-fieldset-footer">
      <p>NOTE: You can switch between results using links on top.</p>
    </div>
    """
  end
end
