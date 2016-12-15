defmodule Day12 do
  def run do
    instructions = load_instructions

    IO.puts run_instruction(instructions, 0, {0, 0, 0, 0}) |> get("a")
    IO.puts run_instruction(instructions, 0, {0, 0, 1, 0}) |> get("a")
  end

  def run_instruction(instructions, instruction_pointer, registers) when instruction_pointer >= length(instructions) do
    registers
  end

  def run_instruction(instructions, instruction_pointer, registers) do
    instruction = Enum.at(instructions, instruction_pointer)

    registers = case instruction do
      ["cpy", source, register] ->
        set(registers, register, source)

      ["inc", register] ->
        set(registers, register, get(registers, register) + 1)

      ["dec", register] ->
        set(registers, register, get(registers, register) - 1)

      ["jnz", _, _] ->
        registers
    end

    movement = case instruction do
      ["jnz", source, location] ->
        if get(registers, source) != 0, do: String.to_integer(location), else: 1

      _ -> 1
    end

    run_instruction(instructions, instruction_pointer + movement, registers)
  end

  def load_instructions do
    IO.read(:all)
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
  end

  defp set(registers, register, source) do
    put_elem(registers, register_to_number(register), get(registers, source))
  end

  defp get(registers, source) do
    cond do
      is_number(source) -> source
      Regex.match?(~r/^\d+$/, source) -> String.to_integer(source)
      true -> elem(registers, register_to_number(source))
    end
  end

  def register_to_number(register) do
    (register |> to_charlist |> hd) - 97
  end
end

Day12.run
