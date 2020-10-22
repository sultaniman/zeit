defmodule ZeitWeb.ProxyLive.Form do
  use ZeitWeb, :live_component

  alias Zeit.Proxies

  @impl true
  def update(%{proxy: proxy} = assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, Proxies.change(proxy))
    }
  end

  @impl true
  def handle_event("validate", %{"proxy" => params}, socket) do
    changeset =
      socket.assigns.proxy
      |> Proxies.change(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end


  @impl true
  def handle_event("save", %{"proxy" => params}, socket) do
    save_proxy(socket, socket.assigns.action, params)
  end

  defp save_proxy(socket, :edit, params) do
    IO.inspect(socket.assigns)
    case Proxies.update(socket.assigns.proxy, params) do
      {:ok, _proxy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Proxy updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_proxy(socket, :new, params) do
    case Proxies.create(params) do
      {:ok, _proxy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Proxy created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
