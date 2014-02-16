defmodule Xkcd.SubSupervisor do
  use Supervisor.Behaviour

  def start_link(storage) do
    result = {:ok, sup} = :supervisor.start_link(__MODULE__, [])
    start_workers(sup, storage)
  end

  def start_workers(sup, storage) do
    ticker = :supervisor.start_child sup, worker(Xkcd.Ticker, [storage])
    :supervisor.start_child sup, worker(Xkcd.controller, [storage, ticker])
  end

  def init do
    supervise [], strategy: :one_for_one
  end
end