defmodule Discovery.Helpers do
  @moduledoc """
  Bunch of helper functions
  """
  alias Zeit.Proxies

  @max_redirects 2

  def get_proxies do
    couple = fn proxy ->
      [proxy, get_proxy(proxy.address)]
    end

    Proxies.list()
    |> Enum.map(couple)
  end

  def get_proxy(uri) when is_binary(uri) do
    get_proxy(URI.parse(uri))
  end

  def get_proxy(%URI{scheme: "socks5"} = uri) do
    config = [
      proxy: {:socks5, to_charlist(uri.host), uri.port},
      # follow_redirect: true,
      # max_redirect: @max_redirects
    ]

    if uri.userinfo do
      [user, pass] = String.split(uri.userinfo, ":")
      config
      |> Keyword.put(:socks5_user, user)
      |> Keyword.put(:socks5_pass, pass)
    else
      config
    end
  end

  def get_proxy(uri) do
    config = [
      proxy: to_charlist(uri.host),
      # follow_redirect: true,
      # max_redirect: @max_redirects
    ]

    if uri.userinfo do
      config
      |> Keyword.put(:proxy_auth, String.split(uri.userinfo, ":"))
    else
      config
    end
  end

  def duration(start_ms) do
    System.monotonic_time(:millisecond) - start_ms
  end
end
