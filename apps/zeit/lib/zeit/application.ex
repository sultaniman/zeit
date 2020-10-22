defmodule Zeit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Zeit.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Zeit.PubSub}
      # Start a worker by calling: Zeit.Worker.start_link(arg)
      # {Zeit.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Zeit.Supervisor)
  end
end
