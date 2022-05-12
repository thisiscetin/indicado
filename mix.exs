defmodule Indicado.MixProject do
  use Mix.Project

  def project do
    [
      app: :indicado,
      version: "0.0.4",
      elixir: "~> 1.12",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      aliases: aliases(),
      preferred_cli_env: [
        "test.ci": :test
      ],
      dialyzer: [
        plt_add_apps: [:ex_unit],
        plt_core_path: "_build/#{Mix.env()}",
        flags: [:error_handling, :race_conditions, :underspecs]
      ],

      # Docs
      name: "Indicado",
      source_url: "https://github.com/thisiscetin/indicado",
      homepage_url: "https://github.com/thisiscetin/indicado",
      docs: [
        main: "Indicado",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Technical indicator library for Elixir with no dependencies.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Mehmet Cetin"],
      licenses: ["Apache 2.0"],
      links: %{
        "Github" => "https://github.com/thisiscetin/indicado",
        "Docs" => "https://hexdocs.pm/indicado"
      }
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      "test.ci": [
        "format --check-formatted",
        "deps.unlock --check-unused",
        "credo --strict",
        "test --raise",
        "dialyzer"
      ]
    ]
  end
end
