defmodule Xkcd.CLI do
  @moduledoc """
  Handels the command line parsing and dispatch to various functions
  which end up fetching a choosen xkcd comic stip with title and alt text.
  """

  import :random, only: [uniform: 1]
  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  def process(:help) do
    IO.puts """
    usage xkcd <number> | xkcd --random
    """
    System.halt(0)
  end
  def process(:random) do
    process(:random.uniform(1300))
  end
  def process(number) do
    Xkcd.Strip.fetch(number)
      |> decode_response
      |> download_image
      |> print
  end

  def download_image({:ok, json}) do
    {:ok, image} = Xkcd.Strip.get(json["img"])
    File.write("./#{extract_filename(json["img"])}", image)
    {:ok, json}
  end
  def extract_filename(image_url) do
    Regex.named_captures(%r/\/(?<filename>[^\/]*\.png)/g, image_url)[:filename]
  end

  def print({:ok, json}) do
    IO.puts json["title"]
    # IO.puts json["img"]
    IO.puts json["alt"]
  end
  def print({:error, body}) do
    IO.puts "Error decoding json #{body}"
    System.halt(2)
  end
  def decode_response({:ok, body}), do: JSON.decode(body)
  def decode_response({:error, _body}) do
    IO.puts "Error fetching from xkcd.com"
    System.halt(2)
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it the number of the xkcd comic to fetch.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean, random: :boolean],
                                     aliases:  [ h:    :help   , r:      :random])
    case parse do
    { [ help: true ],_,_ } -> :help
    { [ random: true ],_,_ } -> :random
    { _,[number],_ } -> binary_to_integer(number)
    _ -> :current
    end
  end
end

