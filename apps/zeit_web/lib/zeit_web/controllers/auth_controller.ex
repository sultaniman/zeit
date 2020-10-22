defmodule ZeitWeb.AuthController do
  @moduledoc false
  use ZeitWeb, :controller
  alias ZeitWeb.Router.Helpers, as: Routes
  alias ZeitWeb.AuthHelpers

  require Logger

  plug Ueberauth

  def login(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    Logger.error("Login failed: #{inspect(fails)}")

    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: Routes.page_path(conn, :login))
  end

  def login(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    AuthHelpers.login(conn, auth)
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
