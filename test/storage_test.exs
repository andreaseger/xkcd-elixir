defmodule StorageTest do
  use ExUnit.Case
  alias Xkcd.Storage

  test "can set a state by key" do
    storage = Storage.start_link
    Storage.set_state(storage, :test, :bla)
    assert :bla == Storage.get_state(storage, :test)
  end
  test "can set multiple keys independently" do
    storage = Storage.start_link
    Storage.set_state(storage, :test, :bla)
    Storage.set_state(storage, :test2, :foo)
    Storage.set_state(storage, :test3, :bar)
    assert :bla == Storage.get_state(storage, :test)
    assert :foo == Storage.get_state(storage, :test2)
    assert :bar == Storage.get_state(storage, :test3)
  end
end