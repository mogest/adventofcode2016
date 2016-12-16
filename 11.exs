#
# Sorry, this code is terrible.
# I spent too long on it though to be in the mood to tidy it!
#
defmodule Day11 do
  import Paco
  import Paco.Parser
  alias Paco.ASCII

  def run do
    {:ok, part_a_universe} = IO.read(:all) |> parse(parser)

    part_b_universe = make_part_b_universe(part_a_universe)

    IO.puts execute([{0, part_a_universe, 0}], MapSet.new)
    IO.puts execute([{0, part_b_universe, 0}], MapSet.new)
  end

  def make_part_b_universe(universe) do
    [
      hd(universe) ++ [
       generator: "elerium", microchip: "elerium", generator: "dilithium", microchip: "dilithium"
      ] | tl(universe)
    ]
  end

  def execute([], _), do: []

  def execute(universes, seen_universes) do
    [{floor, universe, step_count} | tail_universes] = universes

    if success?(universe) do
      step_count
    else
      objects = Enum.at(universe, floor)

      single_indexes = for index <- 0..length(objects) - 1, do: [index]
      double_indexes = for index_1 <- 0..length(objects) - 1, index_2 <- index_1..length(objects) - 1, index_1 != index_2, do: [index_1, index_2 - 1]

      both_indexes = single_indexes ++ double_indexes

      movements = for next_floor <- floor - 1..floor + 1, next_floor != floor, next_floor >= 0, next_floor < length(universe), do: next_floor

      {results, new_seen_universes} = Enum.flat_map_reduce(movements, seen_universes, fn next_floor, seen_universes ->
        next_floor_objects = Enum.at(universe, next_floor)

        Enum.flat_map_reduce(both_indexes, seen_universes, fn set, seen_universes ->
          {cur, next} = Enum.reduce(set, {objects, next_floor_objects}, fn index, {cur, next} ->
            object = Enum.at(cur, index)
            {List.delete_at(cur, index), [object | next]}
          end)

          new_universe = universe
                         |> List.replace_at(floor, cur)
                         |> List.replace_at(next_floor, next)

          key = universe_key(new_universe, next_floor)

          if !Enum.member?(seen_universes, key) && valid?(new_universe) do
            {[{next_floor, new_universe, step_count + 1}], MapSet.put(seen_universes, key)}
          else
            {[], seen_universes}
          end
        end)
      end)

      new_universes = tail_universes ++ results

      execute(new_universes, new_seen_universes)
    end
  end

  def seen_universe?(seen_universes, universe, floor) do
    Enum.member?(seen_universes, universe_key(universe, floor))
  end

  def universe_key(universe, floor) do
    floors = Enum.map(universe, fn objects ->
      floor_values(objects)
      |> Enum.sort
      |> Enum.join
    end)

    [floor | floors]
    |> Enum.join(",")
  end

  def success?([[] | tail]) when length(tail) == 1, do: true
  def success?([[] | tail]), do: success?(tail)
  def success?(_), do: false

  def valid?(universe), do: Enum.all?(universe, &valid_floor?/1)

  def floor_values(objects) do
    Enum.reduce(objects, %{}, fn
      {:generator, name}, safety ->
        if Map.has_key?(safety, name) do
          Map.put(safety, name, :genchip)
        else
          Map.put(safety, name, :generator)
        end

      {:microchip, name}, safety ->
        if Map.has_key?(safety, name) do
          Map.put(safety, name, :genchip)
        else
          Map.put(safety, name, :microchip)
        end
    end)
    |> Map.values
  end

  def valid_floor?(objects) do
    values = floor_values(objects)

    Enum.all?(values, fn name -> name == :genchip || name == :generator end) ||
      Enum.all?(values, fn name -> name == :microchip end)
  end

  def parser do
    nothing = "nothing relevant" |> replace_with([])

    generator = while(ASCII.lowercase, at_least: 1)
    |> followed_by(" generator")
    |> bind(&{:generator, &1})

    microchip = while(ASCII.lowercase, at_least: 1)
    |> followed_by("-compatible microchip")
    |> bind(&{:microchip, &1})

    item_preface = [
      "," |> lex |> maybe,
      "and" |> lex |> maybe,
      one_of([lex("a"), lex("an")])
    ]

    item = one_of([generator, microchip])
           |> preceded_by(item_preface)

    items = item |> repeat

    preface = while(ASCII.lowercase, at_least: 1)
              |> preceded_by("The ")
              |> followed_by(" floor contains ")

    one_of([nothing, items])
    |> preceded_by(preface)
    |> followed_by(".")
    |> line
    |> repeat
  end
end

Day11.run
