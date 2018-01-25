defmodule Sushi.Application do
  use Application

  def start(_type, _args) do
    children = [
      Sushi.ComputerSystem,
      Sushi.ChefSupervisor,
      {Sushi.Cashier, %{}}
    ]

    opts = [strategy: :one_for_one, name: Sushi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

