defmodule CliTest do
  use ExUnit.Case

  import Xkcd.CLI, only: [parse_args: 1]

  test ":help returned by providing -h or --help options" do
    assert parse_args(["-h",    "meeh"]) == :help
    assert parse_args(["--help","meeh"]) == :help
  end
  test ":random returned by providing -r or --random options" do
    assert parse_args(["-r",      "meep"]) == :random
    assert parse_args(["--random","meep"]) == :random
  end
  test "number return if one is given" do
    assert parse_args(["234"]) == 234
  end
end
