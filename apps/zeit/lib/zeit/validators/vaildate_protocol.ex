defmodule Zeit.Validators.ValidateProtocol do
  @moduledoc false
  import Ecto.Changeset

  @valid_protocols ~w(socks5 http https)s
  @doc """
  Validate if protocol is one of `socks5`, `http` or `https`
  """
  def validate_protocol(%Ecto.Changeset{} = change) do
    validate_change(change, :address, fn _, address ->
      case valid_protocol?(address) do
        true ->
          []

        false ->
          [address: "Invalid protocol, should be one of socks5, http, https"]
      end
    end)
  end

  defp valid_protocol?(url) do
    parsed = URI.parse(url)
    Enum.member?(@valid_protocols, parsed.scheme)
  end
end
