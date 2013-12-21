defmodule Xkcd.Strip do
  
  alias HTTPotion.Response

  @user_agent [ "User-agent": "Elixir sch1zo@oho.io"]
  def fetch(number) do
    case HTTPotion.get(strip_url(number), @user_agent) do
      Response[body: body, status_code: status, headers: _headers]
      when status in 200..299 ->
        {:ok, body}
      Response[body: body, status_code: _status, headers: _headers] ->
        {:error, body}
    end
  end

  def strip_url(:current) do
    "http://xkcd.com/info.0.json"
  end
  def strip_url(number) do
    "http://xkcd.com/#{number}/info.0.json"
  end
end
