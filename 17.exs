defmodule Day17 do
  @input "pxxbnzuo"
  @size 4
  @start {0, 0}
  @destination {3, 3}
  @open_door_identifiers "BCDEF"
  @directions [{0, -1, "U"}, {0, 1, "D"}, {-1, 0, "L"}, {1, 0, "R"}]

  def run do
    shortest_path
    longest_length
  end

  def shortest_path do
    search(@start, "")
    |> Enum.min_by(&String.length/1)
    |> IO.puts
  end

  def longest_length do
    search(@start, "")
    |> Enum.map(&String.length/1)
    |> Enum.max
    |> IO.puts
  end

  def search(@destination, path), do: [path]

  def search({x, y}, path) do
    :crypto.hash(:md5, "#{@input}#{path}")
    |> Base.encode16
    |> String.slice(0, 4)
    |> String.graphemes
    |> Enum.map(&String.contains?(@open_door_identifiers, &1))
    |> Enum.zip(@directions)
    |> Enum.filter(fn {valid, _} -> valid end)
    |> Enum.map(fn {_, {dx, dy, dir}} -> {x + dx, y + dy, dir} end)
    |> Enum.filter(fn {nx, ny, _} -> nx >= 0 && nx < @size && ny >= 0 && ny < @size end)
    |> Enum.flat_map(fn {nx, ny, dir} -> search({nx, ny}, path <> dir) end)
  end
end

Day17.run
