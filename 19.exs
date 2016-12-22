defmodule Day19a do
  def run do
    1..3012210
    |> Enum.to_list
    |> reduce([])
    |> IO.puts
  end

  def reduce([elf | []], []),        do: elf
  def reduce([], rest),              do: reduce(Enum.reverse(rest), [])
  def reduce([elf | []], rest),      do: reduce([elf | Enum.reverse(rest)], [])
  def reduce([elf, _ | tail], rest), do: reduce(tail, [elf | rest])
end

defmodule Day19b do
  def run do
    1..3012210
    |> Enum.to_list
    |> reduce
    |> IO.puts
  end

  def reduce([elf | []]), do: elf

  def reduce(elfs) do
    count = length(elfs)
    third = div(count - 1, 3)
    half = div(count, 2)
    offset = rem(count, 2)

    a = Enum.slice(elfs, 0..third)
    b = Enum.slice(elfs, third + 1..half - 1)
    c = Enum.slice(elfs, half..-1) |> skip_2_in_3(offset)

    reduce(b ++ c ++ a)
  end

  def skip_2_in_3(list, start) do
    list
    |> Enum.flat_map_reduce(start, fn val, 2 -> {[val], 0}
                                      _, n   -> {[], n + 1} end)
    |> elem(0)
  end
end

Day19a.run
Day19b.run

