defmodule ZeitWeb.PageController do
  use ZeitWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    if conn.assigns.user do
      conn
      |> redirect(to: Routes.site_index_path(conn, :index))
      |> halt()
    else
      render(conn, "signin.html")
    end
  end
end
