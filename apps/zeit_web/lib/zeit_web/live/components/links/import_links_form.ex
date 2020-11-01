defmodule ZeitWeb.Components.ImportLinksForm do
  @moduledoc false
  use ZeitWeb, :live_component

  alias Zeit.Links
  alias Zeit.Validators.ValidateLinks

  @impl true
  def render(assigns) do
    ~L"""
    <%= f = form_for @site_links, "#",
      id: "site-form",
      phx_target: @myself,
      phx_submit: "save" %>

      <div class="zi-fieldset-content modal__content site-form">
        <h1><%= @title %> :: <%= domain(@site.address) %></h1>
        <div class="site-form__form">
          <div class="form__row">
            <%= textarea f, :links, class: "site-form__links", placeholder: "one link per line like " <> @site.address <> "/awesome/path" %>
            <%= error_tag f, :links %>
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
  def handle_event("save", %{"site_links" => %{"links" => links}}, socket) do
    site = socket.assigns.site

    {valid_links, invalid_links} =
      links
      |> String.split(["\n", "\r\n"], trim: true)
      |> ValidateLinks.validate(site.address)

    {:ok, _} =
      valid_links
      |> Links.prepare_many(socket.assigns.site.id)
      |> Links.create_many()

    {
      :noreply,
      socket
      |> put_flash(
        :info,
        "#{length(valid_links)} links created, #{length(invalid_links)} links skipped"
      )
      |> push_redirect(to: socket.assigns.return_to)
    }
  end
end
