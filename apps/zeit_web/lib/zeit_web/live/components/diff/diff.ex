defmodule ZeitWeb.Components.Diff do
  use ZeitWeb, :live_component
  alias ZeitWeb.{Differ, Statuses}

  @impl true
  def render(assigns) do
    ~L"""
    <div class="diff zi-fieldset-content modal__content">
      <h4 class="card__title">
        <%= String.upcase(domain(@link.address)) %> ::
        <div class="diff__selector">
          <%= for {proxy, index} <- Enum.with_index(@proxies |> Map.values()) do %>
            <a
              class="diff__<%= if @other.proxy_id == proxy.id do %>active<% else %>inactive<% end %>"
              phx-target="<%= @myself %>" phx-click="select-other" phx-value-proxy_id="<%= proxy.id %>">
              <%= proxy.name %>
            </a> <%= if index < length(@proxies |> Map.values()) - 1 do %> | <% end %>
          <% end %>
        </div>
      </h4>

      <div class="diff__viewer">
      <%= for [mode, header, first, second] <- Differ.calculate_diff(@direct, @other, @proxies) do %>
        <div class="<%= mode %> diffs">
          <span class="diffs__header"><%= header %></span>
          <span class="diffs__first"><%= first %></span>
          <span class="diffs__second"><%= second %></span>
        </div>
        <%= if String.downcase(header) == "headers" do %>
        <div class="diffs diffs--report">
          <span class="diffs__header">&nbsp;</span>
          <span class="diffs__first report report--packed">
            <span class="zi-badge <%= snapshot_status_color(@direct) %> dot" data-balloon-pos="up">&nbsp;</span>
            <%= format_bytes(@direct.size) %> /
            <span aria-label="<%= Statuses.format(@direct.http_status) %>" data-balloon-pos="up"><%= @direct.http_status %></span> /
            <%= @direct.request_duration/1000 %>s
          </span>
          <span class="diffs__second report report--packed">
            <span class="zi-badge <%= snapshot_status_color(@direct) %> dot" data-balloon-pos="up">&nbsp;</span>
            <%= format_bytes(@other.size) %> /
            <span aria-label="<%= Statuses.format(@other.http_status) %>" data-balloon-pos="up"><%= @other.http_status %></span> /
            <%= @other.request_duration/1000 %>s
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

  @impl true
  def handle_event(
        "select-other",
        %{"proxy_id" => proxy_id},
        %{assigns: %{over_proxy: over_proxy}} = socket
      ) do
    other =
      Enum.find(over_proxy, fn s ->
        s.proxy_id == proxy_id
      end)

    {
      :noreply,
      socket
      |> assign(:other, other)
    }
  end
end
