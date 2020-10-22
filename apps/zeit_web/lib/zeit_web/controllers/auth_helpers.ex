defmodule ZeitWeb.AuthHelpers do
  use Zeit.Schema

  import Plug.Conn, only: [put_session: 3]
  import Phoenix.Controller, only: [redirect: 2]

  alias Zeit.Users

  def login(conn, auth) do
    {:ok, user, redirect_url} = prepare_response(auth)

    conn
    |> put_session(:user, user)
    |> redirect(to: redirect_url)
  end

  defp prepare_response(auth) do
    redirect_url = Application.get_env(:zeit_web, :login_redirect)

    {:ok, user} =
      Users.get_or_create(%{
        email: auth.info.email,
        full_name: auth.info.name,
        is_admin: false,
        provider: "google"
      })

    {:ok, user, redirect_url}
  end
end
