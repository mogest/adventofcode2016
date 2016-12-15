defmodule Day15 do
  def run do
    configuration = load_configuration

    IO.puts simulate(configuration)
    IO.puts simulate(configuration |> List.insert_at(-1, {7, 11, 0}))
  end

  def simulate(configuration) do
    Stream.iterate(0, fn time -> time + 1 end)
    |> Stream.map(&{&1, position_calculator(configuration, &1)})
    |> Stream.filter(&all_zero?/1)
    |> Enum.at(0)
    |> elem(0)
  end

  def load_configuration do
    IO.read(:all)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&parser/1)
  end

  def parser(line) do
    [disc, positions, 0, start_position] = Regex.scan(~r/\d+/, line)
    |> List.flatten
    |> Enum.map(&String.to_integer/1)

    {disc, positions, start_position}
  end

  def position_calculator(configuration, time) do
    Enum.map(configuration, fn {disc, positions, start_position} ->
      rem(disc + start_position + time, positions)
    end)
  end

  def all_zero?({_, discs}) do
    Enum.all?(discs, & &1 == 0)
  end
end

Day15.run
