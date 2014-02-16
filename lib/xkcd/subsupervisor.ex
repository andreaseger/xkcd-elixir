defmodule Xkcd.SubSupervisor do
  use Supervisor.Behaviour
  def start_link(storage) do
    :supervisor.start_link(__MODULE__, storage)
  end
  def init(storage) do
    child_processes = [ worker(Xkcd.Ticker, [storage]) ]
    supervise child_processes, strategy: :one_for_one
  end
end