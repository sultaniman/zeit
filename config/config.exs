# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :zeit,
  ecto_repos: [Zeit.Repo]

config :zeit_web,
  ecto_repos: [Zeit.Repo],
  generators: [context_app: :zeit, binary_id: true],
  login_redirect: "/sites"

# Configures the endpoint
config :zeit_web, ZeitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "liSbm56wwG9QMZ1YWQ3a9mbKYaFL/IpWGN/ZoZGJVw7BhUe+PS//2uLJM70ZB8Fe",
  render_errors: [view: ZeitWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Zeit.PubSub,
  live_view: [signing_salt: "UOKy9l8f"],
  check_origin: false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Ueberauth
config :ueberauth, Ueberauth,
  base_path: "/login",
  providers: [
    google: {
      Ueberauth.Strategy.Google,
      [
        default_scope: "email profile",
        prompt: "select_account",
        access_type: "offline"
      ]
    }
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :discovery, Discovery.Scheduler,
  timezone: :utc,
  jobs: [
    # Schedules
    # */1 * * * * every minute
    # */5 * * * * every 5 minutes
    # */15 * * * * every 15 minutes
    # 0 * * * * every hour
    # Hourly
    {"0 * * * *", {Discovery.Pipeline, :run, []}},
    # {"*/5 * * * *", {Discovery.Pipeline, :run, []}}
    {"0 * * * *", {Discovery.Pipeline.Lookups, :run, []}}
  ]

# Describes ETL stages
config :discovery,
  uploader: Discovery.S3Storage,
  snaphots_path: "snapshots"

# AWS
config :ex_aws,
  access_key_id: [System.get_env("AWS_ACCESS_KEY_ID"), {:awscli, "default", 30}, :instance_role],
  secret_access_key: [System.get_env("AWS_SECRET_ACCESS_KEY"), {:awscli, "default", 30}, :instance_role],
  region: System.get_env("AWS_REGION"),
  json_codec: Jason,
  s3: [
    scheme: "https://",
    host: System.get_env("AWS_S3_BUCKET_URL")
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
