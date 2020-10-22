defmodule ZeitWeb.ModalComponent do
  use ZeitWeb, :live_component

  @class "modal"

  @impl true
  def render(assigns) do
    ~L"""
    <div
      id="<%= @id %>"
      class="<%= klass(@opts) %>"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-page-loading>

      <div class="modal__wrapper">
        <%= live_patch raw("&times;"), to: @return_to, class: "modal__close" %>
        <%= live_component @socket, @component, @opts %>
      </div>
    </div>
    """
  end

  def klass(opts) do
    class = Keyword.get(opts, :class, "")

    cond do
      class == "" -> @class
      true -> "#{@class} #{class}"
    end
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
