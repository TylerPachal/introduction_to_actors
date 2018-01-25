defmodule Sushi.Cashier do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Logger.info("[#{__MODULE__}] #{inspect self()} Starting")

    # Start 3 chefs
    {:ok, _pid} = Supervisor.start_child(Sushi.ChefSupervisor, [])
    {:ok, _pid} = Supervisor.start_child(Sushi.ChefSupervisor, [])
    {:ok, _pid} = Supervisor.start_child(Sushi.ChefSupervisor, [])

    {:ok, state}
  end

  # In-store order
  def handle_call({:order, name, count}, _from, state) do
    Logger.info("[#{__MODULE__}] #{inspect self()} Received in-store order from #{inspect name}")

    # Tell the system about the next order
    GenServer.cast(Sushi.ComputerSystem, {:triage, name, count})

    # Update our collection of inflight orders
    updated_state = Map.put(state, name, count)

    # Respond to the customer and update our state
    {:reply, :thank_you, updated_state}
  end

  # Online order
  def handle_cast({:order, name, count}, state) do
    Logger.info("[#{__MODULE__}] #{inspect self()} Received online order from #{inspect name}")

    # Tell the chef manager about the next order
    GenServer.cast(Sushi.ComputerSystem, {:triage, name, count})

    # Update our collection of inflight orders
    updated_state = Map.put(state, name, count)

    # Update our state
    {:noreply, updated_state}
  end

  # Chef notifying us and order is done
  def handle_cast({:done, name, rolls}, state) do
    Logger.info("[#{__MODULE__}] #{inspect self()} Received message from the manager that food is ready for #{inspect name}")

    # Yell the customers name because their food is ready
    GenServer.cast(name, rolls)

    # Update our collection of inflight orders
    updated_state = Map.delete(state, name)

    # Update our state
    {:noreply, updated_state}
  end
end