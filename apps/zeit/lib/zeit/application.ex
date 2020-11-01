defmodule Zeit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  @hackney_checkout_timeout 30_000
  @hackney_max_connections 10_000
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Zeit.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Zeit.PubSub}
      # Start a worker by calling: Zeit.Worker.start_link(arg)
      # {Zeit.Worker, arg}
    ]

    :ok =
      :hackney_pool.start_pool(
        :fetcher,
        timeout: @hackney_checkout_timeout,
        max_connections: @hackney_max_connections
      )

    Supervisor.start_link(children, strategy: :one_for_one, name: Zeit.Supervisor)
  end
end
