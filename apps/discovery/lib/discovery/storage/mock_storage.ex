defmodule Discovery.MockStorage do
  @moduledoc """
  Uploader which does nothing and only serves
  testing purposes.
  """
  def upload(path, _data), do: {:ok, path}

  def name_only?, do: false
end
