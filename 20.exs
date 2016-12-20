defmodule Day20 do
  def run do
    ranges = calculate_ranges

    ranges |> find_first_allowed |> IO.puts
    ranges |> find_allowed_count |> IO.puts
  end

  def calculate_ranges do
    IO.read(:all)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, "-") |> Enum.map(&String.to_integer/1) end)
    |> Enum.sort_by(&hd/1)
  end

  def find_first_allowed(ranges) do
    Enum.reduce_while(ranges, 0, fn [a, b], acc ->
      cond do
        a > acc -> {:halt, acc}
        b < acc -> {:cont, acc}
        true    -> {:cont, b + 1}
      end
    end)
  end

  def find_allowed_count(ranges) do
    Enum.reduce(ranges, {0, 0}, fn [a, b], {acc, count} ->
      cond do
        a > acc -> {b + 1, count + a - acc}
        b < acc -> {acc, count}
        true    -> {b + 1, count}
      end
    end)
    |> elem(1)
  end
end

Day20.run
