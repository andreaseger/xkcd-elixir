defmodule TickerTest do
  use ExUnit.Case
  alias Xkcd.Ticker
  alias Xkcd.Storage

  test "starts with empty client list" do
    storage = Storage.start_link
    ticker = Ticker.start_link(storage)
    assert [] == Ticker.clients(ticker)
  end

  test "client can be registered" do
    storage = Storage.start_link
    ticker = Ticker.start_link(storage)
    Ticker.register ticker, self
    assert [self] == Ticker.clients(ticker)
  end

  test "client can be deregistered" do
    storage = Storage.start_link
    ticker = Ticker.start_link(storage, 100, [self])
    Ticker.deregister ticker, self
    assert [] == Ticker.clients(ticker)
  end

  # TODO test this behaviour in a real client
  test "client will receive a tick" do
    storage = Storage.start_link
    _ticker = Ticker.start_link(storage, 10,[self])
    # assert_receive( {:"$gen_cast", :tick})

    assert_receive(:tick,11,"no :tick after 11 milliseconds")
    assert_receive(:tick,11,"no second :tick after another max 22 milliseconds")
    assert_receive(:tick,11,"no third  :tick after another max 33 milliseconds")
  end
end