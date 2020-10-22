defmodule Zeit.Proxies.Proxy do
  @moduledoc false
  use Zeit.Model
  import Zeit.Validators.ValidateProtocol

  schema "proxies" do
    field :name, :string
    field :address, :string

    timestamps()
  end

  @doc false
  def changeset(proxy, attrs) do
    proxy
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
    |> validate_protocol()
  end
end
