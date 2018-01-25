defmodule Sushi.Chef do
  use GenServer

  @possibilities ["salmon", "tuna", "crab", "shrimp tempura", "cucumber", "california"]

  def handle_cast({:細巻き, name, count}, state) do
    IO.puts("#{__MODULE__} Making #{count} rolls for #{inspect name}")

    # Prepare each roll
    rolls = make_rolls(count, [])

    # Tell the cashier we are done this order
    GenServer.cast(Sushi.Cashier, {:done, name, rolls})

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