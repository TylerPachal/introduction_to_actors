defmodule SushiTest do
  use ExUnit.Case
  doctest Sushi

  test "greets the world" do
    assert Sushi.hello() == :world
  end
end
