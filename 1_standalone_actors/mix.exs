defmodule Sushi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :sushi,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: []
    ]
  end
end
