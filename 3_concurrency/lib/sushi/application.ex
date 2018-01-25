defmodule Sushi.Application do
  use Application

  def start(_type, _args) do
    children = [
      Sushi.ComputerSystem,
      Sushi.ChefSupervisor,
      {Sushi.Cashier, %{}}
    ]

    # Using :rest_for_one, because if the ComputerSystem dies,
    # we need the chefs to also restart, so they can subscribe
    # to the new ComputerSystem
    opts = [strategy: :rest_for_one, name: Sushi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

