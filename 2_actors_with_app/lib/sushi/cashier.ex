defmodule Sushi.Cashier do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    IO.puts("#{__MODULE__} Starting")
    {:ok, state}
  end

  # In-store order
  def handle_call({:order, name, count}, _from, state) do
    IO.puts("#{__MODULE__} Received in-store order from #{inspect name}")

    # Tell the chef about the next order
    GenServer.cast(Sushi.Chef, {:細巻き, name, count})

    # Update our collection of inflight orders
    updated_state = Map.put(state, name, count)

    # Respond to the customer and update our state
    {:reply, :thank_you, updated_state}
  end

  # Online order
  def handle_cast({:order, name, count}, state) do
    IO.puts("#{__MODULE__} Received online order from #{inspect name}")

    # Tell the chef about the next order
    GenServer.cast(Sushi.Chef, {:細巻き, name, count})

    # Update our collection of inflight orders
    updated_state = Map.put(state, name, count)

    # Update our state
    {:noreply, updated_state}
  end

  # Chef notifying us and order is done
  def handle_cast({:done, name, rolls}, state) do
    IO.puts("#{__MODULE__} Received message from chef that food is ready for #{inspect name}")

    # Yell the customers name because their food is ready
    GenServer.cast(name, rolls)

    # Update our collection of inflight orders
    updated_state = Map.delete(state, name)

    # Update our state
    {:noreply, updated_state}
  end
end