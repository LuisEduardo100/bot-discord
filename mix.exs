defmodule MeuBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :meu_bot,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [run: :dev]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :dotenv],
      mod: {MeuBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:nostrum, "~> 0.8"},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]}
    ]
  end
end
