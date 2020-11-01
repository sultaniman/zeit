defmodule Zeit.Snapshots.Snapshot do
  @moduledoc false
  use Zeit.Model

  alias Zeit.Links.Link
  alias Zeit.Proxies.Proxy
  alias Zeit.Sites.Site

  schema "snapshots" do
    # Path to stored snapshot
    field :path, :string

    # Page size in bytes
    field :size, :integer

    # Status code
    field :http_status, :integer

    # Response headers
    field :http_headers, :map

    # How long it took to get the response back
    field :request_duration, :float

    field :error, :string

    # Group timestamp to keep all
    # results in a single bucket
    field :timestamp, :integer

    belongs_to :proxy, Proxy
    belongs_to :link, Link
    belongs_to :site, Site

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(%Snapshot{} = snapshot, attrs) do
    fields =
      ~w(path link_id site_id proxy_id http_status http_headers timestamp request_duration retries error)a

    required_fields =
      ~w(path link_id site_id http_status http_headers timestamp request_duration retries error)a

    snapshot
    |> cast(attrs, fields)
    |> validate_required(required_fields)
    |> foreign_key_constraint(:link_id)
    |> foreign_key_constraint(:site_id)
  end
end
