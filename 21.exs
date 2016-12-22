defmodule Day21 do
  def run do
    instructions = load_instructions

    IO.puts forward(instructions, "abcdefgh")
    IO.puts backward(instructions, "fbgdceah")
  end

  def load_instructions do
    IO.read(:all)
    |> String.strip
    |> String.split("\n")
  end

  def forward(instructions, input),  do: execute(instructions, input, false)
  def backward(instructions, input), do: execute(instructions |> Enum.reverse, input, true)

  def execute(instructions, input, reverse) do
    Enum.reduce(instructions, input |> String.graphemes, fn line, output ->
      numbers = Regex.scan(~r/\d+/, line)
                |> List.flatten
                |> Enum.map(&String.to_integer/1)

      words = String.split(line, " ")

      [w1, w2 | _] = words
      command = "#{w1} #{w2}"

      case command do
        "swap position" ->
          [index_1, index_2] = numbers
          x = Enum.at(output, index_1)
          y = Enum.at(output, index_2)
          output |> List.replace_at(index_1, y) |> List.replace_at(index_2, x)

        "swap letter" ->
          [_, _, x, _, _, y] = words
          index_1 = Enum.find_index(output, & &1 == x)
          index_2 = Enum.find_index(output, & &1 == y)
          output |> List.replace_at(index_1, y) |> List.replace_at(index_2, x)

        "reverse positions" ->
          [index_1, index_2] = numbers

          Enum.slice(output, 0, index_1) ++
            Enum.reverse(Enum.slice(output, index_1..index_2)) ++
            Enum.slice(output, index_2 + 1..-1)

        "rotate left" ->
          [count] = numbers
          if reverse, do: rotate_right(output, count), else: rotate_left(output, count)

        "rotate right" ->
          [count] = numbers
          if reverse, do: rotate_left(output, count), else: rotate_right(output, count)

        "rotate based" ->
          [_, _, _, _, _, _, letter] = words
          index = Enum.find_index(output, & &1 == letter)
          rotate_based(output, index, reverse)

        "move position" ->
          [index_1, index_2] = if reverse, do: Enum.reverse(numbers), else: numbers
          letter = Enum.at(output, index_1)
          output |> List.delete_at(index_1) |> List.insert_at(index_2, letter)
      end
    end)
    |> Enum.join
  end

  def rotate_based(output, index, false) do
    count = 1 + index + if(index >= 4, do: 1, else: 0)
    rotate_right(output, count)
  end

  def rotate_based(output, index, true) do
    count = %{1 => 1, 3 => 2, 5 => 3, 7 => 4, 2 => 6, 4 => 7, 6 => 0, 0 => 1}[index]
    rotate_left(output, count)
  end

  def rotate_left(output, 0), do: output
  def rotate_left(output, count) do
    rotate_left(tl(output) ++ [hd output], count - 1)
  end

  def rotate_right(output, 0), do: output
  def rotate_right(output, count) do
    rotate_right([Enum.at(output, -1)] ++ Enum.slice(output, 0..-2), count - 1)
  end
end

Day21.run
