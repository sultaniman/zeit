defmodule ZeitWeb.Middleware.AuthRequired do
  @moduledoc false
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]
  alias Zeit.Users
  alias ZeitWeb.Router.Helpers

  require Logger

  def init(_params) do
  end

  @doc false
  def call(conn, _params) do
    if valid_user?(conn) do
      conn
    else
      Logger.notice("Redirecting to login...")

      conn
      |> redirect(to: Helpers.page_path(conn, :login))
      |> halt()
    end
  end

  defp valid_user?(conn) do
    user = Map.get(conn.assigns, :user)

    case Users.get!(user.id) do
      nil -> false
      _ -> conn.assigns.authenticated
    end
  end
end
