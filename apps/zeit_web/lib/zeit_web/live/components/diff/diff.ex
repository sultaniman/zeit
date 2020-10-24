defmodule ZeitWeb.Components.Diff do
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="diff zi-fieldset-content modal__content">
      <h4 class="card__title">
        <%= String.upcase(domain(@link.address)) %> ::
        <div class="diff__selector">
          <%= for {proxy, index} <- Enum.with_index(@proxies) do %>
            <a
              class="diff__<%= if @other.proxy_id == proxy.id do %>active<% else %>inactive<% end %>"
              phx-target="<%= @myself %>" phx-click="select-other" phx-value-proxy_id="<%= proxy.id %>">
              <%= proxy.name %>
            </a> <%= if index < length(@proxies) - 1 do %> | <% end %>
          <% end %>
        </div>
      </h4>

      <div class="diff__viewer">
      <%= for [mode, header, first, second] <- calculate_diff(@direct, @other) do %>
        <div class="<%= mode %> diffs">
        <span class="diffs__header"><%= header %></span>
        <span><%= first %></span>
        <span><%= second %></span>
        </div>
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
    %{assigns: %{over_proxy: over_proxy}}= socket
  ) do
    other = Enum.find(over_proxy, fn s ->
      s.proxy_id == proxy_id
    end)

    {
      :noreply,
      socket
      |> assign(:other, other)
    }
  end

  defp calculate_diff(%{http_headers: first}, %{http_headers: second}) do
    first
    |> extract_headers(second)
    |> Enum.map(fn h ->
      if first[h] != second[h] do
        [:different, cap_header(h), first[h], second[h]]
      else
        [:similar, cap_header(h), first[h], second[h]]
      end
    end)
  end

  defp extract_headers(first, second) do
    original_keys =
      first
      |> Map.keys()

    other_keys=
      second
      |> Map.keys()
      |> Enum.reject(&Enum.member?(original_keys, &1))

    original_keys ++ other_keys
  end

  defp cap_header(header) do
    header
    |> String.split("-")
    |> Enum.map(&String.capitalize(&1))
    |> Enum.join("-")
  end
end
