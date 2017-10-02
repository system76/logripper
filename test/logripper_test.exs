defmodule LogripperTest do
  use ExUnit.Case
  doctest Logripper

  test "greets the world" do
    assert Logripper.hello() == :world
  end
end
