# 3) Concurrency

In this example, we achieve by having multiple chefs making sushi simaltaneously.  We introduce a new [computer_system.ex](lib/sushi/computer_system.ex) that takes input orders from the cashier, and triages them to the least busy chef.  The functionality for the triage is pretty naive, it is just for example purposes.

The [cashier](lib/sushi/cashier.ex) is also now responsible for starting the chefs, by asking their supervisor to do so.  When a chef is started, it sends a message to the computer system to let the system know that they are ready for orders.

```
$ iex -S mix

Generated sushi app

14:31:26.240 [info]  [Elixir.Sushi.ComputerSystem] #PID<0.117.0> Starting

14:31:26.240 [info]  [Elixir.Sushi.ChefSupervisor] #PID<0.118.0> Starting

14:31:26.241 [info]  [Elixir.Sushi.Cashier] #PID<0.119.0> Starting

14:31:26.242 [info]  [Elixir.Sushi.Chef] #PID<0.120.0> Starting

14:31:26.242 [info]  [Elixir.Sushi.ComputerSystem] Chef #PID<0.120.0> has clocked in

14:31:26.242 [info]  [Elixir.Sushi.Chef] #PID<0.121.0> Starting

14:31:26.242 [info]  [Elixir.Sushi.ComputerSystem] Chef #PID<0.121.0> has clocked in

14:31:26.242 [info]  [Elixir.Sushi.Chef] #PID<0.122.0> Starting

14:31:26.242 [info]  [Elixir.Sushi.ComputerSystem] Chef #PID<0.122.0> has clocked in
```

You can send orders and kill processes like in the previous example:
```
iex(1)> GenServer.call(Sushi.Cashier, {:order, self(), 2})

14:33:59.183 [info]  [Elixir.Sushi.Cashier] #PID<0.126.0> Received in-store order from #PID<0.130.0>

14:33:59.183 [info]  [Elixir.Sushi.ComputerSystem] New order for #PID<0.130.0>

14:33:59.183 [info]  Elixir.Sushi.Chef #PID<0.127.0> Making 2 rolls for #PID<0.130.0>
:thank_you

Elixir.Sushi.ComputerSystem #PID<0.124.0> Received message from a chef that food is ready for #PID<0.130.0>

14:34:03.190 [info]  [Elixir.Sushi.Cashier] #PID<0.126.0> Received message from the manager that food is ready for #PID<0.130.0>

nil
iex(2)> flush()
{:"$gen_cast", ["cucumber", "tuna"]}
:ok
```

