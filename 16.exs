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

  def calculate_checksum(data) when rem(length(data), 2) == 0 do
    data
    |> Enum.chunk(2)
    |> Enum.map(fn [a, a] -> 1; _ -> 0 end)
    |> calculate_checksum
  end

  def calculate_checksum(data), do: data
end

Day16.run
