defmodule Sushi do
  import IEx.Helpers

  ## Test this using IEX
  ## iex -S mix
  ## Sushi.test()
  def test do
    # Create the chef
    {:ok, _pid} = GenServer.start_link(Sushi.Chef, :ok, name: Sushi.Chef)

    # Create the cashier
    {:ok, cashier_pid} = GenServer.start_link(Sushi.Cashier, %{}, name: Sushi.Cashier)

    # Place an order
    GenServer.call(cashier_pid, {:order, self(), 2})

    # Wait for a bit then check the messages we received
    Process.sleep(5_000)
    flush()
  end
end

