defmodule StripTest do
  use ExUnit.Case

  import Xkcd.Strip, only: [strip_url: 1]

  test "return a proper json url for a numbered comic" do
    assert strip_url(345) == "http://xkcd.com/345/info.0.json"
    assert strip_url(731) == "http://xkcd.com/731/info.0.json"
    assert strip_url(425) == "http://xkcd.com/425/info.0.json"
  end
  test ":current return the url to the current comics json" do
    assert strip_url(:current) == "http://xkcd.com/info.0.json"
  end
end
