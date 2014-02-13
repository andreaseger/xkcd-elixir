defmodule Xkcd.Ticker do
  use GenServer.Behaviour

  # Public API

  def start_link(stash_pid, interval \\ 2000, clients \\ []) do
    {:ok, ticker} = :gen_server.start_link(__MODULE__, {interval, clients, stash_pid}, [])
    ticker
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

  def handle_cast({:register, pid}, {interval, clients, stash_pid}) do
    {:noreply, {interval, Enum.uniq(clients ++ [pid]), stash_pid}}
  end

  def handle_cast({:deregister, pid}, {interval, clients, stash_pid}) do
    {:noreply, {interval, clients -- [pid], stash_pid}}
  end

  def handle_call(:clients, _from, state={_, clients, _}) do
    {:reply, clients, state}
  end

  # defp terminate(_reason, {interval, clients, stash_pid}) do
  #  Stash.save_ticker stash_pid, {interval, clients}
  # end
end
