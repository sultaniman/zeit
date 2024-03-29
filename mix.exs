defmodule Zeit.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [
        zeit_machine: [
          applications: [
            zeit: :permanent,
            zeit_web: :permanent,
            discovery: :permanent
          ]
        ]
      ]
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["cmd mix setup"]
    ]
  end
end
