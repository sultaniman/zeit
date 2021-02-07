defmodule ZeitWeb.Components.Preview do
  use ZeitWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="preview zi-fieldset-content modal__content">
      <h4 class="card__title">
        PREVIEW: <%= String.upcase(@link.address) %> <%= if @snapshot.proxy_id do %>VIA <%= String.upcase(@proxies[@snapshot.proxy_id].name) %> <% end %>
      </h4>

      <div class="preview__iframe">
        <iframe src="<%= Routes.preview_path(@socket, :index, @snapshot.id) %>"></iframe>
      </div>
    </div>
    <div class="modal__footer zi-fieldset-footer">
      <p>NOTE: This is just HTML representation of snapshot.</p>
    </div>

    <style>
    .preview {
      height: 88vh;
    }

    .preview__iframe iframe {
      border: 0;
      width: 100%;
      height: 84vh;
    }
    </style>
    """
  end
end
