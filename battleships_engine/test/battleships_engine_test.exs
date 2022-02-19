defmodule BattleshipsEngineTest do
  use ExUnit.Case
  doctest BattleshipsEngine

  test "greets the world" do
    assert BattleshipsEngine.hello() == :world
  end
end
