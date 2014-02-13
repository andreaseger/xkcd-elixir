defmodule FetcherTest do
  use ExUnit.Case

  import Xkcd.Fetcher, only: [strip_url: 1,
                              decode_response: 1,
                              extract_date: 1,
                              get_xkcd: 1]

  @xkcd431_json "{\"month\": \"6\", \"num\": 431, \"link\": \"\", \"year\": \"2008\", \"news\": \"\", \"safe_title\": \"Delivery\", \"transcript\": \"[[In a delivery room]]\\nDoctor:  There's the head... he's looking at me... Wait, he's crawling back into the womb.\\nMother:  What?!\\nDoctor:  Yeah, it's the darnedest thing.\\nMother: Um, what does it mean?\\nDoctor:  My guess?  Six more weeks of winter.\\n{{title text: Ma'am, I admit that wasn't in the best taste, but you have to admire my delivery!  Ha ha, get it?  Oh God, don't throw those syringes!  Your baby's fine!}}\", \"alt\": \"Ma'am, I admit that wasn't in the best taste, but you have to admire my delivery!  Ha ha, get it?  Oh God, don't throw those syringes!  Your baby's fine!\", \"img\": \"http:\\/\\/imgs.xkcd.com\\/comics\\/delivery.png\", \"title\": \"Delivery\", \"day\": \"2\"}"

  test "return a proper json url for a numbered comic" do
    assert strip_url(345) == "http://xkcd.com/345/info.0.json"
    assert strip_url(731) == "http://xkcd.com/731/info.0.json"
    assert strip_url(425) == "http://xkcd.com/425/info.0.json"
  end
  test ":current return the url to the current comics json" do
    assert strip_url(:current) == "http://xkcd.com/info.0.json"
  end

  test "dates can be extracted from the xkcd json" do
    {:ok, dict} = decode_response({:ok, @xkcd431_json})
    assert Date.from({2008,6,2}) == extract_date(dict)
  end
  test "fetching metadata for a numbered xkcd" do
    strip = Strip[number: 123, title: "Centrifugal Force", imageurl: "http://imgs.xkcd.com/comics/centrifugal_force.png", alt: "You spin me right round, baby, right round, in a manner depriving me of an inertial reference frame.  Baby.", date: Date.Gregorian[date: {2006, 7, 3}, time: {0, 0, 0}, tz: {0.0, "UTC"}], url: "http://xkcd.com/123", mobile_url: "http://m.xkcd.com/123"]
    assert strip == get_xkcd(123)
  end
end
