defmodule Day09b do
  def run do
    IO.read(:all)
    |> String.strip
    |> String.graphemes
    |> Enum.reduce({0, nil, []}, fn char, {output, command, multipliers} ->
         cond do
           command && char == ")" ->
             {len, multiplier} = parse_command(command)
             {output, nil, [{len, multiplier} | step(multipliers)]}

           command ->
             {output, command <> char, step(multipliers)}

           char == "(" ->
             {output, "", step(multipliers)}

           true ->
             {output + current_multiplier(multipliers), nil, step(multipliers)}
         end
       end)
    |> elem(0)
    |> IO.puts
  end

  def parse_command(command) do
    [_, len, multiplier] = Regex.run(~r/^(\d+)x(\d+)$/, command)

    {String.to_integer(len), String.to_integer(multiplier)}
  end

  def current_multiplier(multipliers) do
    Enum.reduce(multipliers, 1, fn {_, multiplier}, acc -> acc * multiplier end)
  end

  def step(multipliers) do
    Enum.filter_map(
      multipliers,
      fn {len, _} -> len > 0 end,
      fn {len, multiplier} -> {len - 1, multiplier} end
    )
  end
end

Day09b.run
