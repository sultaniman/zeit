defmodule ZeitWeb.Components.Note do
  @moduledoc false
  use ZeitWeb, :live_component

  def render(assigns) do
    ~L"""
      <p
        class="note note--info" role="alert"
        phx-click="lv:clear-flash"
        phx-value-key="info"><%= live_flash(@flash, :info) %></p>

      <p
        class="note note--alert"
        role="alert"
        phx-click="lv:clear-flash"
        phx-value-key="error"><%= live_flash(@flash, :error) %></p>
    """
  end
end
