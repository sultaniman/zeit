defmodule ZeitWeb.ReportLive.Index do
  use ZeitWeb, :live_view

  alias Zeit.{Proxies, Sites, Snapshots}
  alias ZeitWeb.Statuses

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
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp make_report(user) do
    user
    |> Sites.get_by_user()
    |> Enum.map(&Snapshots.report_latest/1)
  end
end
