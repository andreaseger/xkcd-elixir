defmodule Xkcd.Storage do
  use GenServer.Behaviour

  # Public API
  def start_link do
    {:ok, storage} = :gen_server.start_link(__MODULE__, HashDict.new, [])
    storage
  end

  def set_state(pid, key, value) do
    :gen_server.cast pid, {:set_state, {key, value}}
  end

  def get_state(pid, key) do
    :gen_server.call pid, {:get_state, key}
  end

  # GenServer API
  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call({:get_state, key}, _from, dict) do
    {:reply, dict[key], dict}
  end

  def handle_cast({:set_state, {key, value}}, dict) do
    {:noreply, Dict.put(dict, key, value)}
  end
end

