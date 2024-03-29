defmodule Zeit.Release do
  @moduledoc false
  @apps [
    :zeit,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(:zeit, :ecto_repos)
  end

  defp load_app do
    Enum.each(@apps, &Application.ensure_all_started/1)
  end
end
