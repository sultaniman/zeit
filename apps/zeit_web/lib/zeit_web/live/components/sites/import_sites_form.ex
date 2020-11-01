defmodule ZeitWeb.Components.ImportSitesForm do
  @moduledoc false
  use ZeitWeb, :live_component
  import Ecto.Changeset, only: [get_field: 3]
  alias Zeit.Sites
  alias Zeit.Sites.SiteList

  @impl true
  def render(assigns) do
    ~L"""
    <%= f = form_for @site_list, "#",
      id: "site-form",
      phx_target: @myself,
      phx_submit: "save" %>
      <div class="zi-fieldset-content modal__content site-form">
        <h1><%= @title %></h1>
        <div class="site-form__form">
          <div class="form__row">
            <%= textarea f, :sites, class: "site-form__links", placeholder: "one site per line" %>
            <%= error_tag f, :sites %>
          </div>
          <div class="form__row">
            <span>Enforce https?</span>
            <%= checkbox f, :enforce_https %>
          </div>
        </div>
      </div>

      <div class="modal__footer zi-fieldset-footer">
        <p><%= @note_text %></p>
        <%= submit @submit_text, phx_disable_with: "Saving...", class: "zi-btn mini auto primary" %>
      </div>

      <style>
        .site-form__links {
          width: 96%;
          height: 240px;
          border: 1px solid #aaa;
          border-radius: 4px;
          padding: 5px 10px;
        }
      </style>
    </form>
    """
  end

  @impl true
  def handle_event("save", %{"site_list" => params}, socket) do
    changes = SiteList.changeset(params)
    sites = get_field(changes, :sites, "")
    enforce_https = get_field(changes, :enforce_https, true)

    imported =
      sites
      |> String.split(["\n", "\r\n"], trim: true)
      |> Sites.prepare_many(socket.assigns.user.id, enforce_https)
      |> Sites.create_many()

    {
      :noreply,
      socket
      |> put_flash(:info, "Import #{inspect(imported)}")
      |> push_redirect(to: socket.assigns.return_to)
    }
  end
end
