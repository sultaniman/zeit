defmodule ZeitWeb.ReportLive.Index do
  use ZeitWeb, :live_view

  alias Zeit.{Proxies, Sites, Snapshots}
  alias Zeit.Sites.Site
  alias ZeitWeb.{Statuses, Strings}

  @impl true
  def mount(_params, %{"user" => user} = _session, socket) do
    {
      :ok,
      socket
      |> assign(:report, make_report(user))
      |> assign(:proxies, Proxies.list())
      |> assign(:user, user)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, socket}
  end

  def get_error(nil), do: ""
  def get_error(error) do
    cond do
      String.contains?(error, "certificate_expired") -> "Certificate expired"
      String.contains?(error, "handshake_failure") -> "Handshake error"
      String.contains?(error, "bad_certificate") -> "Bad certificate"
      true -> error
    end
  end

  defp make_report(user) do
    user
    |> Sites.get_by_user()
    |> Enum.map(&Snapshots.report_latest/1)
  end
end
