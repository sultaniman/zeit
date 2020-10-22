defmodule Zeit.Model do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      alias __MODULE__

      # Set all datetimes to UTC by default
      @timestamps_opts [type: :utc_datetime_usec]
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
