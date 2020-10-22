defmodule ZeitWeb.Components.Compare do
  @moduledoc false
  use ZeitWeb, :live_component

  def render(assigns) do
    ~L"""
    <button class="compare zi-btn mini success">COMPARE</button>
    """
  end
end
