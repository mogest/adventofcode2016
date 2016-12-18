defmodule Day18 do
  def run do
    row = IO.read(:all)
    |> String.strip
    |> String.graphemes
    |> Enum.map(fn "^" -> false; "." -> true end)

    solution(row, 40) |> IO.puts
    solution(row, 400000) |> IO.puts
  end

  def solution(row, row_count) do
    next_row(row, safe_tiles(row), row_count - 1)
  end

  def next_row(_, safe, 0), do: safe

  def next_row(row, safe, count) do
    new_row = calculate_row(row)

    next_row(new_row, safe + safe_tiles(new_row), count - 1)
  end

  def safe_tiles(row) do
    row
    |> Enum.filter(& &1)
    |> Enum.count
  end

  def calculate_row(row) do
    row
    |> Enum.with_index
    |> Enum.map(fn {center, index} ->
         left = if index > 0, do: Enum.at(row, index - 1), else: true
         right = if index < length(row) - 1, do: Enum.at(row, index + 1), else: true

         case {left, center, right} do
           {false, false, true} -> false
           {true, false, false} -> false
           {false, true, true} -> false
           {true, true, false} -> false
           _ -> true
         end
       end)
  end
end

Day18.run
