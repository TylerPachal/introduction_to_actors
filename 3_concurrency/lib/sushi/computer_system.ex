defmodule Sushi.ComputerSystem do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def init(state) do
    Logger.info("[#{__MODULE__}] #{inspect self()} Starting")
    {:ok, state}
  end

  def handle_call(:chef_clock_in, {chef_pid, _}, state) do
    Logger.info("[#{__MODULE__}] Chef #{inspect chef_pid} has clocked in")

    # Monitor the chef, so we will be notified when he dies
    Process.monitor(chef_pid)

    # Update our state, to keep track of how much work each chef is doing
    updated_state = Map.put(state, chef_pid, 0)
    {:reply, :ok, updated_state}
  end

  def handle_cast({:triage, name, count}, state) do
    Logger.info("[#{__MODULE__}] New order for #{inspect name}")

    # Find the least busy chef, and send them the order
    {chef, rolls} = least_busy_chef(state)
    GenServer.cast(chef, {:細巻き, name, count})

    # Update our state of each chef's roll count
    updated_state = Map.put(state, chef, rolls + count)
    {:noreply, updated_state}
  end

  def handle_cast({:done, name, rolls}, state) do
    IO.puts("#{__MODULE__} #{inspect self()} Received message from a chef that food is ready for #{inspect name}")
    GenServer.cast(Sushi.Cashier, {:done, name, rolls})
    {:noreply, state}
  end

  def handle_info({:DOWN, _, _, chef_pid, reason}, state) do
    Logger.info("[#{__MODULE__}] Chef #{inspect chef_pid} down with reason: #{reason}")
    updated_state = Map.delete(state, chef_pid)
    {:noreply, updated_state}
  end

  defp least_busy_chef(map) do
    map
    |> Map.to_list()
    |> List.keysort(1)
    |> List.first()
  end

end