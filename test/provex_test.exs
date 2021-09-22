defmodule ProvexTest do
  use ExUnit.Case
  doctest Provex

  test "greets the world" do
    assert Provex.hello() == :world
  end
end
