defmodule Xkcd.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    result = {:ok, sup} = :supervisor.start_link(__MODULE__, [])
    start_workers(sup)
  end

  def start_workers(sup) do
    storage = :supervisor.start_child sup, worker(Xkcd.Storage, [])
    # set interval to 5 minutes
    Xkcd.Storage.set_state(storage, :ticker_interval, 5*60*1000)

    :supervisor.start_child(sup, supervisor(Xkcd.SubSupervisor, [storage]))
  end
  def init do
    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise([], strategy: :one_for_one)
  end
end
