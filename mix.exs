defmodule Logripper.Mixfile do
  use Mix.Project

  def project do
    [
      app: :logripper,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:ex_aws, :hackney, :logger, :sweet_xml],
      mod: {Logripper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:csv, "~> 2.0.0"},
      {:ecto, "~> 2.0"},
      {:ex_aws, "~> 1.1"},
      {:hackney, "~> 1.9"},
      {:mariaex, "~> 0.8.2"},
      {:sweet_xml, "~> 0.6.5"},
    ]
  end
end
