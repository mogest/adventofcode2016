defmodule Day16 do
  #@size 272
  @size 35651584
  @input "11110010111001001"

  def run do
    @input
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    |> expand
    |> Enum.take(@size)
    |> calculate_checksum
    |> Enum.join
    |> IO.puts
  end

  def expand(data) when length(data) >= @size, do: data
  def expand(data),                            do: expand(data ++ [0 | mutate(data)])

  def mutate(data), do: Enum.reduce(data, [], &[1 - &1 | &2])

  def calculate_checksum(data) do
    data
    |> Enum.chunk(2)
    |> Enum.map(fn [a, a] -> 1; _ -> 0 end)
    |> rerun_if_even
  end

  def rerun_if_even(checksum) when rem(length(checksum), 2) == 0, do: calculate_checksum(checksum)
  def rerun_if_even(checksum),                                    do: checksum
end

Day16.run
