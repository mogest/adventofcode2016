# I just did part A with code.  Part B was easier to work out mathematically.

defmodule Day22 do
  def run do
    nodes = IO.read(:all)
    |> String.strip
    |> String.split("\n")
    |> Enum.drop(2)
    |> Enum.map(&parse/1)

    for(a <- nodes, b <- nodes, a != b, do: {a, b})
    |> Enum.filter(fn {[_, _, _, used, _, _], [_, _, _, _, b_avail, _]} -> used > 0 && used <= b_avail end)
    |> Enum.count
    |> IO.puts
  end

  def parse(line) do
    Regex.scan(~r/\d+/, line)
    |> List.flatten
    |> Enum.map(&String.to_integer/1)
  end
end

Day22.run
