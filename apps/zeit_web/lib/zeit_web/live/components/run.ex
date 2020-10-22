defmodule ZeitWeb.Components.Run do
  @moduledoc false
  use ZeitWeb, :live_component
  def mount(_socket, _params, _) do
  end

  def render(assigns) do
    ~L"""
    <div class="run">
      <span aria-label="Run checks" data-balloon-pos="down">
        <img class="site-details__run" src="<%= Routes.static_path(@socket, "/images/icons/play-green.svg") %>"/>
      </span>
      <style scoped>
      </style>
    </div>
    """
  end
end
