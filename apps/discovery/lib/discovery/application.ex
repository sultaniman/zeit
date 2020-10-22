defmodule Discovery.Application do
  @moduledoc false
  use Application

  @opts [
    strategy: :one_for_one,
    name: Discovery.Supervisor
  ]

  @children [
    Discovery.Scheduler
  ]

  @impl true
  def start(_type, _args) do
    Supervisor.start_link(@children, @opts)
  end
end
