defmodule Day25 do
  def run do
    instructions = load_instructions

    Stream.iterate(1, & &1 + 1)
    |> Stream.map(&{&1, run_instruction(instructions, 0, {&1, 0, 0, 0}, [])})
    |> Stream.filter(fn {_, success} -> success end)
    |> Enum.at(0)
    |> elem(0)
    |> IO.puts
  end

  def run_instruction(_, _, _, output) when length(output) == 10 do
    output == [1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
  end

  def run_instruction(instructions, instruction_pointer, registers, output) do
    instruction = Enum.at(instructions, instruction_pointer)

    registers = case instruction do
      ["cpy", source, register] ->
        set(registers, register, source)

      ["inc", register] ->
        set(registers, register, get(registers, register) + 1)

      ["dec", register] ->
        set(registers, register, get(registers, register) - 1)

      _ ->
        registers
    end

    movement = case instruction do
      ["jnz", source, location] ->
        if get(registers, source) != 0, do: get(registers, location), else: 1

      _ -> 1
    end

    new_instructions = case instruction do
      ["tgl", location] ->
        pointer = instruction_pointer + get(registers, location)

        if pointer < 0 || pointer >= length(instructions) do
          instructions
        else
          instructions
          |> List.update_at(pointer, &process_tgl(&1))
        end

      _ -> instructions
    end

    new_output = case instruction do
      ["out", source] -> [get(registers, source) | output]
      _               -> output
    end

    run_instruction(new_instructions, instruction_pointer + movement, registers, new_output)
  end

  def load_instructions do
    IO.read(:all)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
  end

  defp set(registers, register, source) do
    case register_to_number(register) do
      number when number >= 0 and number <= 3 ->
        put_elem(registers, number, get(registers, source))

      _ ->
        registers
    end
  end

  defp get(registers, source) do
    cond do
      is_number(source) -> source
      Regex.match?(~r/^-?\d+$/, source) -> String.to_integer(source)
      true -> elem(registers, register_to_number(source))
    end
  end

  def register_to_number(register) do
    (register |> to_charlist |> hd) - 97
  end

  def process_tgl(instruction) do
    case instruction do
      ["inc", register] -> ["dec", register]
      [_, a]            -> ["inc", a]
      ["jnz", a, b]     -> ["cpy", a, b]
      [_, a, b]         -> ["jnz", a, b]
    end
  end
end

Day25.run
