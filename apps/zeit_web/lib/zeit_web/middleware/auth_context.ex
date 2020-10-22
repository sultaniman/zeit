defmodule ZeitWeb.Middleware.AuthContext do
  @moduledoc """
  Lookup user in session and assign to conn.
  Also it takes care of passing current user
  as context value to absinthe so later in
  resolvers we can access it like

  ```elixir
  def my_resolver(_parent, _args, %{context: %{user: user}} = _params) do
    # ...
  end
  ```
  """
  import Plug.Conn
  alias Zeit.Users

  def init(_params) do
  end

  @doc false
  def call(conn, _params) do
    if Application.get_env(:zeit_web, :skip_auth, false) do
      conn
      |> put_session(:user, Users.list() |> List.first())
    else
      case get_session(conn, :user) do
        nil ->
          no_user(conn)

        user ->
          conn
          |> assign(:user, user)
          |> assign(:authenticated, true)
      end
    end
  end

  defp no_user(conn) do
    conn
    |> assign(:user, nil)
    |> assign(:authenticated, false)
  end
end
