defmodule Discovery.MixProject do
  use Mix.Project

  def project do
    [
      app: :discovery,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :retry],
      mod: {Discovery.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:flow, "~> 1.0"},
      {:retry, "~> 0.14.1"},
      {:typed_struct, "~> 0.2.1"},
      {:httpoison, "~> 1.7"},
      {:quantum, "~> 3.3"},
      {:timex, "~> 3.6"},
      {:gen_stage, "~> 1.0", override: true},
      {:codepagex, "~> 0.1.6"},
      {:gen_icmp, github: "msantos/gen_icmp"},
      {:procket, github: "msantos/procket", override: true},

      # AWS
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:sweet_xml, "~> 0.6"},
      {:configparser_ex, "~> 4.0"},
      {:ex_aws_sts, "~> 2.1"},

      # To handle temporary files
      {:briefly, github: "CargoSense/briefly"},

      {:mimic, "~> 1.3", only: :test},
      {:httparrot, "~> 1.3", only: :test, override: true},
      {:zeit, in_umbrella: true},
    ]
  end
end
