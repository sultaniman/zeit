defmodule Discovery.Box do
  @moduledoc false
  use TypedStruct
  alias Zeit.Links.Link
  alias Zeit.Proxies.Proxy

  @typedoc "Request configuration"
  typedstruct do
    field(:timestamp, pos_integer())
    field(:link, Link.t())
    field(:proxy, Proxy.t())
    field(:config, Keyword.t())
  end
end
