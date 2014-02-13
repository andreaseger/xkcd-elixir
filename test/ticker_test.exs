defmodule TickerTest do
  use ExUnit.Case

  test "starts with empty client list" do
    ticker = Xkcd.Ticker.start_link(self, 100)
    assert [] == Xkcd.Ticker.clients(ticker)
  end
  test "client can be registered" do
    ticker = Xkcd.Ticker.start_link(self, 100)
    Xkcd.Ticker.register ticker, self
    assert [self] == Xkcd.Ticker.clients(ticker)
  end
  test "client can be deregistered" do
    ticker = Xkcd.Ticker.start_link(self, 100,[self])
    Xkcd.Ticker.deregister ticker, self
    assert [] == Xkcd.Ticker.clients(ticker)
  end

  # TODO test this behaviour in a real client
  test "client will receive a tick" do
    _ticker = Xkcd.Ticker.start_link(self, 10,[self])
    # assert_receive( {:"$gen_cast", :tick})

    assert_receive(:tick,11,"no :tick after 11 milliseconds")
    assert_receive(:tick,11,"no second :tick after another max 22 milliseconds")
    assert_receive(:tick,11,"no third  :tick after another max 33 milliseconds")
  end
end