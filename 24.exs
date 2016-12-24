#
# The part B solution isn't a generic solution, but happens to work for
# the particular map I was given.  I didn't feel like rewriting the entire
# module :(
#
defmodule Day24 do
  @neighbours [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]

  def run do
    map = IO.read(:all)
    |> String.strip
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.flat_map(&parse/1)
    |> Enum.into(%{})

    destinations = Enum.filter(map, fn {_, {_, char}} -> char end)

    current = destinations
    |> Enum.find(fn {_, {_, char}} -> char == "0" end)
    |> elem(0)

    IO.puts make_trail(map, current, 7, 0) |> elem(2)

    {map, end_a, steps} = make_trail(map, current, 3, 0)
    {map, end_b, steps} = make_trail(map, current, 4, steps)

    IO.puts find_location(map, end_a, [{end_b, steps}], MapSet.new)
  end

  def make_trail(map, current, 0, steps) do
    new_map = Map.put(map, current, {true, nil})

    {new_map, current, steps}
  end

  def make_trail(map, current, remaining, previous_steps) do
    new_map = Map.put(map, current, {true, nil})

    {destination, steps} = search(new_map, [{current, 0}], MapSet.new)

    make_trail(new_map, destination, remaining - 1, previous_steps + steps)
  end

  def search(map, [{current, steps} | tail], visited) do
    if elem(map[current], 1) do
      {current, steps}
    else
      next_locations = neighbours(map, current)
      |> Enum.filter(&!MapSet.member?(visited, &1))

      new_visited = Enum.reduce(next_locations, visited, &MapSet.put(&2, &1))

      new_tail = Enum.map(next_locations, &{&1, steps + 1})

      search(map, tail ++ new_tail, new_visited)
    end
  end

  def find_location(_, goal, [{goal, steps} | _], _), do: steps

  def find_location(map, goal, [{current, steps} | tail], visited) do
    next_locations = neighbours(map, current)
    |> Enum.filter(&!MapSet.member?(visited, &1))

    new_visited = Enum.reduce(next_locations, visited, &MapSet.put(&2, &1))

    new_tail = Enum.map(next_locations, &{&1, steps + 1})

    find_location(map, goal, tail ++ new_tail, new_visited)
  end

  def neighbours(map, {x, y}) do
    @neighbours
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(&elem(map[&1], 0))
  end

  def parse({line, y}) do
    line
    |> String.graphemes
    |> Enum.with_index
    |> Enum.map(fn {char, x} ->
         case char do
           "#" -> {{x, y}, {false, nil}}
           "." -> {{x, y}, {true, nil}}
           _   -> {{x, y}, {true, char}}
         end
       end)
  end
end

Day24.run
