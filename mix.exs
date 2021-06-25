defmodule Indicado.MixProject do
  use Mix.Project

  def project do
    [
      app: :indicado,
      version: "0.0.1",
      elixir: "~> 1.12",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),

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

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
