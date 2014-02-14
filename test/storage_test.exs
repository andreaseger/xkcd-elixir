defmodule StorageTest do
  use ExUnit.Case
  alias Xkcd.Storage

  test "can get the current state" do
    storage = Storage.start_link(:bla)
    assert :bla == Storage.get_state(storage)
  end
  test "initial state default to empty tuple" do
    storage = Storage.start_link
    assert {} == Storage.get_state(storage)
  end
  test "can save a new state" do
    storage = Storage.start_link
    Storage.save_state storage, {:new_state}
    assert {:new_state} == Storage.get_state(storage)
  end
end