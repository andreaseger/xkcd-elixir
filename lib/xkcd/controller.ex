defmodule Xkcd.Controller do
  use GenServer.Behaviour

  # Public API
  def start_link(storage, ticker) do
    {:ok, controller} = :gen_server.start_link __MODULE__, [storage, ticker], []
    controller
  end

  def init(storage, ticker) do
    last_comic = Xkcd.Storage.get_state storage, :last_comic
    Xkcd.Ticker.register ticker, self
    {:ok, {last_comic, {storage, ticker} } }
  end

  def handle_info(:tick, {last_comic, pids}) do
    IO.puts "tick"
    comic = update_comic(last_comic)
    {:noreply, {comic, pids}}
  end

  def terminate(_reason, {last_comic, {storage,ticker}}) do
    Xkcd.Ticker.deregister ticker, self
    Xkcd.Storage.set_state storage, :last_comic, last_comic
  end

  defp update_comic(last_comic) do
    current_comic = Xkcd.Fetcher.current_comic
    if current_comic.number == last_comic
      last_comic
    else
      comics = Enum.map (last_comic+1)..(current_comic.number-1), fn(i) ->
        Xkcd.Fetcher.get_xkcd(i)
      end
      comics = comics ++ [current_comic]
      Enum.each comics, fn(comic) ->
        tweet(comic)
      end
      current_comic.number
    end
  end

  defp tweet(comic) do
    IO.inspect comic
  end
end