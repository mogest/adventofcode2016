defmodule Day09b do
  import Paco
  import Paco.Parser
  alias Paco.ASCII

  def run do
    {:ok, tokens} = IO.read(:all) |> String.strip |> parse(parser)

    Enum.reduce(tokens, {0, []}, fn
      [len, multiplier, string_length], {count, multipliers} ->
        {count, [{len, multiplier} | step(string_length, multipliers)]}

      _, {count, multipliers} ->
        {count + current_multiplier(multipliers), step(1, multipliers)}
    end)
    |> elem(0)
    |> IO.puts
  end

  def parser do
    number = while(ASCII.digit, at_least: 1) |> bind(&String.to_integer/1)

    command =
      number
      |> separated_by("x")
      |> surrounded_by(ASCII.round_brackets)
      |> bind(fn [a, b] -> [a, b, String.length("#{a}#{b}") + 3] end)

    repeat(one_of(ASCII.uppercase ++ [command]))
  end

  def current_multiplier(multipliers) do
    Enum.reduce(multipliers, 1, fn {_, multiplier}, acc -> acc * multiplier end)
  end

  def step(0, multipliers), do: multipliers

  def step(count, multipliers) do
    step count - 1, Enum.filter_map(
      multipliers,
      fn {len, _} -> len > 0 end,
      fn {len, multiplier} -> {len - 1, multiplier} end
    )
  end
end

Day09b.run
