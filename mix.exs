defmodule TLDR.MixProject do
  use Mix.Project

  def project do
    [
      app: :tl_dr,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TLDR.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.28.4", only: :dev, runtime: false},
      {:finch, "~> 0.9.0"},
      {:jason, "~> 1.2"}
    ]
  end
end
