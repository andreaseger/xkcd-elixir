defmodule Xkcd.Fetcher do
  alias HTTPotion.Response

  @user_agent [ "User-agent": "Elixir sch1zo@oho.io"]

  def get_xkcd(number) do
    {:ok, strip} = fetch(number)
    strip
  end

  defp fetch(number) do
    number
      |> strip_url
      |> get
      |> decode_response
      |> make_strip
  end

  def strip_url(:current), do: "http://xkcd.com/info.0.json"
  def strip_url(number), do: "http://xkcd.com/#{number}/info.0.json"

  def get(url) do
    case HTTPotion.get(url, @user_agent) do
      Response[body: body, status_code: status, headers: _headers]
      when status in 200..299 ->
        {:ok, body}
      Response[body: body, status_code: _status, headers: _headers] ->
        {:error, body}
    end
  end

  def decode_response({:ok, body}), do: JSON.decode(body)
  #def decode_response({:error, _body}), do: :error

  def make_strip({:ok, json}) do
    num = json["num"]
    {:ok, Strip[number: num,
                title: json["safe_title"],
                alt: json["alt"],
                imageurl: json["img"],
                date: extract_date(json),
                url: build_url(num),
                mobile_url: build_mobile_url(num)]}
  end
  # defp make_strip({:error, msg}), do: :error

  def extract_date(dict) do
    year = binary_to_integer(dict["year"])
    month = binary_to_integer(dict["month"])
    day = binary_to_integer(dict["day"])
    Date.from({year,month,day})
  end

  def build_url(number), do: "http://xkcd.com/#{number}"
  def build_mobile_url(number), do: "http://m.xkcd.com/#{number}"
end
