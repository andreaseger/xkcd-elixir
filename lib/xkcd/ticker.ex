defmodule Xkcd.Ticker do
  use GenServer.Behaviour
  alias Xkcd.Storage

  # Public API
  def start_link(stash_pid) do
    interval = Storage.get_state(stash_pid, :ticker_interval) || 1000
    clients = Storage.get_state(stash_pid, :ticker_clients) || []
    start_link(stash_pid, interval, clients)
  end
  def start_link(stash_pid, interval) do
    clients = Storage.get_state(stash_pid, :ticker_clients) || []
    start_link(stash_pid, interval, clients)
  end
  def start_link(stash_pid, interval, clients) do
    {:ok, ticker} = :gen_server.start_link(__MODULE__, {interval, clients, stash_pid}, [])
    ticker
  end

  def set_interval(pid, interval) do
    :gen_server.cast pid, {:set_interval, interval}
  end
  # will add a client to the tickers list of clients
  def register(pid, client) do
    :gen_server.cast pid, {:register, client}
  end
  # will remove a client to the tickers list of clients
  def deregister(pid, client) do
    :gen_server.cast pid, {:deregister, client}
  end
  # returns list of clients for a ticker
  def clients(pid) do
    :gen_server.call pid, :clients
  end
  def stop(pid) do
    :gen_server.call pid, :stop
  end

  # GenServer API
  def init(state={interval,_,_}) do
    Process.send_after(self, :tick, interval)
    {:ok, state}
  end

  def handle_info(:tick, state={interval, clients, _}) do
    # IO.puts "server tick"
    Enum.each clients, fn c ->
      # :gen_server.cast c, :tick
      # Process.send(c, {:tick, "stuff"})
      Process.send(c, :tick)
    end
    Process.send_after(self, :tick, interval)
    {:noreply, state}
  end

  def handle_cast({:set_interval, interval}, {_, clients, stash_pid}) do
    {:noreply, {interval, clients, stash_pid}}
  end

  def handle_cast({:register, pid}, {interval, clients, stash_pid}) do
    {:noreply, {interval, Enum.uniq(clients ++ [pid]), stash_pid}}
  end

  def handle_cast({:deregister, pid}, {interval, clients, stash_pid}) do
    {:noreply, {interval, clients -- [pid], stash_pid}}
  end

  def handle_call(:clients, _from, state={_, clients, _}) do
    {:reply, clients, state}
  end
  def handle_call(:stop, _from, state) do
    {:stop, "regular shutdown", :ok, state}
  end

  def terminate(_reason, {interval, clients, stash_pid}) do
    Storage.set_state stash_pid, :ticker_interval, interval
    Storage.set_state stash_pid, :ticker_clients, clients
  end
end
