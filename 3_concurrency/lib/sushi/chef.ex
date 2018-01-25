defmodule Sushi.Chef do
  use GenServer
  require Logger

  @possibilities ["salmon", "tuna", "crab", "shrimp tempura", "cucumber", "california"]

  def start_link() do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(_ags) do
    Logger.info("[#{__MODULE__}] #{inspect self()} Starting")
    GenServer.call(Sushi.ComputerSystem, :chef_clock_in)
    {:ok, :ok}
  end

  def handle_cast({:細巻き, name, count}, state) do
    IO.puts("#{__MODULE__} #{inspect self()} Making #{count} rolls for #{inspect name}")

    # Prepare each roll
    rolls = make_rolls(count, [])

    # Tell the system we are done this order
    GenServer.cast(Sushi.ComputerSystem, {:done, name, rolls})

    # Update the state (in this case, just pass the existing state)
    {:noreply, state}
  end

  defp make_rolls(count, rolls) when length(rolls) >= count do
    rolls
  end
  defp make_rolls(count, rolls) do
    roll = Enum.random(@possibilities)
    Process.sleep(2_000)
    make_rolls(count, [roll | rolls])
  end
end