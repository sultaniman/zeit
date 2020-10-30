defmodule ZeitWeb.SiteLive.Form do
  use ZeitWeb, :live_component

  alias Zeit.{
    Events,
    Links,
    Sites
  }

  @impl true
  def update(%{site: site} = assigns, socket) do
    changeset = Sites.change(site)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("validate", %{"site" => site_params}, socket) do
    changeset =
      socket.assigns.site
      |> Sites.change(site_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"site" => site_params}, socket) do
    save_site(socket, socket.assigns.action, site_params)
  end

  defp save_site(socket, :edit, site_params) do
    case Sites.update(socket.assigns.site, site_params) do
      {:ok, site} ->
        Events.create(%{
          type: "site:update",
          ref: site.id,
          owner: socket.assigns.user.id,
          data: site_params
        })

        {
          :noreply,
          socket
          |> put_flash(:info, "Site updated successfully")
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_site(socket, :new, site_params) do
    case Sites.create(site_params) do
      {:ok, site} ->
        # Create index page link, give the same address
        # because we assume that the default index is
        # the actual given site address
        Links.create(%{address: site.address, site_id: site.id})

        # Create event log
        Events.create(%{
          type: "site:create",
          ref: site.id,
          owner: socket.assigns.user.id,
          data: site_params
        })

        {
          :noreply,
          socket
          |> put_flash(:info, "Site created successfully")
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
