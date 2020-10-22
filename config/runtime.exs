import Config

database_url =
  System.fetch_env!("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :zeit, Zeit.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "20")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

signing_salt =
  System.get_env("SIGNING_SALT") ||
    raise "environment variable SIGNING_SALT is missing."

config :zeit_web, ZeitWeb.Endpoint,
  server: true,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  live_view: [signing_salt: signing_salt]

config :zeit_web,
  skip_auth: false

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :zeit_web, ZeitWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.fetch_env!("GOOGLE_CLIENT_ID"),
  client_secret: System.fetch_env!("GOOGLE_CLIENT_SECRET")

# AWS
config :ex_aws,
  access_key_id: [System.fetch_env!("AWS_ACCESS_KEY_ID"), {:awscli, "default", 30}, :instance_role],
  secret_access_key: [System.fetch_env!("AWS_SECRET_ACCESS_KEY"), {:awscli, "default", 30}, :instance_role],
  region: System.get_env("AWS_REGION", "us-east-1"),
  json_codec: Jason,
  s3: [
    scheme: "https://",
    host: System.fetch_env!("AWS_S3_BUCKET_URL")
  ]
