defmodule Sushi.ChefSupervisor do
  use Supervisor
  require Logger

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(_) do
    Logger.info("[#{__MODULE__}] #{inspect self()} Starting")
    children = [worker(Sushi.Chef, [], [restart: :permanent])]

    opts = [strategy: :simple_one_for_one, name: :chef_sup]
    Supervisor.init(children, opts)
  end
end

