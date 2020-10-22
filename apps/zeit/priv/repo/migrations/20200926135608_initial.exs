defmodule Zeit.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    # Users
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :full_name, :string
      add :provider, :string
      add :is_admin, :boolean, default: false

      timestamps()
    end

    create index(:users, [:email])
    create index(:users, [:full_name])
    create index(:users, [:provider])

    # Sites
    create table(:sites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :address, :string
      add :is_archive, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:sites, [:address])
    create index(:sites, [:is_archive])

    # Links
    create table(:links, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :address, :string
      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:links, [:address])

    # Proxies
    create table(:proxies, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :address, :string

      timestamps()
    end

    create unique_index(:proxies, [:address])
    create index(:proxies, [:name])

    # Sites <-> Proxies mapping
    create table(:sites_proxies) do
      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)
      add :proxy_id, references(:proxies, on_delete: :delete_all, type: :binary_id)
    end

    # Snapshots
    create table(:snapshots, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :path, :string
      add :http_status, :integer
      add :http_headers, :map
      add :size, :integer
      add :error, :string, null: true
      add :request_duration, :float
      add :timestamp, :integer

      add :proxy_id, references(:proxies, on_delete: :nilify_all, type: :binary_id), null: true
      add :link_id, references(:links, on_delete: :delete_all, type: :binary_id)
      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      # Events are immutable
      timestamps(updated_at: false)
    end

    create index(:snapshots, [:request_duration])
    create index(:snapshots, [:http_status])
    create index(:snapshots, [:timestamp])

    # Lookups
    create table(:lookups, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :inet_address, :string
      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    # Event logs
    create table(:events, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string
      add :ref, :uuid
      add :owner, :string, null: true
      add :data, :map

      # Events are immutable
      timestamps(updated_at: false)
    end

    create index(:events, [:type])
    create index(:events, [:ref])
    create index(:events, [:owner])
  end
end
