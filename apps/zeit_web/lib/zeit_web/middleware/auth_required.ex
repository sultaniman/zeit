defmodule ZeitWeb.Middleware.AuthRequired do
  @moduledoc false
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]
  alias ZeitWeb.Router.Helpers

  require Logger

  def init(_params) do
  end

  @doc false
  def call(conn, _params) do
    if Map.get(conn.assigns, :user) && conn.assigns.authenticated do
      conn
    else
      Logger.info("Redirecting to login...")

      conn
      |> redirect(to: Helpers.page_path(conn, :login))
      |> halt()
    end
  end
end
