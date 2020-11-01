defmodule Discovery.Result do
  @moduledoc false
  use TypedStruct
  alias Discovery.Box
  alias HTTPoison.Response

  @typedoc "Result of request and input"
  typedstruct do
    field(:box, Box.t())
    field(:response, Response.t())
    field(:snapshot_path, binary())
    field(:error, binary())
    field(:duration, non_neg_integer())
  end
end
