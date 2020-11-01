defmodule Discovery.Errors do
  @moduledoc false
  def handle_error(:nxdomain), do: "Domain not found"
  def handle_error(:badarg), do: "Unknown error :badarg"
  def handle_error(:econnrefused), do: "Connection refused"
  def handle_error(:timeout), do: "Request timed out"
  def handle_error(error), do: Jason.encode!(error)
end
