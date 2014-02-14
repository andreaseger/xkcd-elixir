defmodule Xkcd.Storage do
  use GenServer.Behaviour

  # Public API
  def start_link(initial_state \\ {}) do
    {:ok, storage} = :gen_server.start_link(__MODULE__, initial_state, [])
    storage
  end

  def save_state(pid, strip) do
    :gen_server.cast pid, {:save_state, strip}
  end

  def get_state(pid) do
    :gen_server.call pid, :get_state
  end

  # GenServer API
  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call(:get_state, _from, current_strip) do
    {:reply, current_strip, current_strip}
  end

  def handle_cast({:save_state, new_strip}, _current_strip) do
    {:noreply, new_strip}
  end
end

