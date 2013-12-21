defmodule Xkcd.CLI do
  @moduledoc """
  Handels the command line parsing and dispatch to various functions
  which end up fetching a choosen xkcd comic stip with title and alt text.
  """

  import :random, only: [uniform: 1]
  def run(argv) do
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

