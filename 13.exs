defmodule Day13 do
  @magic_number 1364
  @source {1, 1}
  @destination {31, 39}

  def run do
    result = search([[@source]], MapSet.new)

    IO.puts "Part A: #{result}"
  end

  def search([[@destination | path] | _], _) do
    Enum.count(path)
  end

  def search([path | queue], visited) do
    point = {x, y} = hd path

    if length(path) == 51 do
      IO.puts "Part B: #{Enum.count(visited) + 1}"
    end

    surrounding_points = for dx <- -1..1, dy <- -1..1,
      x + dx >= 0, y + dy >= 0, abs(dx) + abs(dy) == 1,
      do: {x + dx, y + dy}

    new_paths = surrounding_points
    |> Enum.filter(fn point -> !MapSet.member?(visited, point) && !wall?(point) end)
    |> Enum.map(fn point -> [point | path] end)

    search(queue ++ new_paths, MapSet.put(visited, point))
  end

  def wall?({x, y}) do
    number = x*x + 3*x + 2*x*y + y + y*y + @magic_number

    ones = Integer.to_string(number, 2) |> String.replace("0", "") |> String.length

    rem(ones, 2) == 1
  end
end

Day13.run
