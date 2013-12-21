defmodule Xkcd.CLI do
  @moduledoc """
  Handels the command line parsing and dispatch to various functions
  which end up fetching a choosen xkcd comic stip with title and alt text.
  """

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
    process(221)
  end
  def process(number) do
    Xkcd.Strip.fetch(number)
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

    end
  end
end
