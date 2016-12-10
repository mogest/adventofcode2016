defmodule Day10 do
  import Paco
  import Paco.Parser
  alias Paco.ASCII

  @part_a_value_search [17, 61]

  def run do
    outputs = IO.read(:all)
    |> parse(parser)
    |> build_universe
    |> simulate_universe

    IO.puts "Part B: #{outputs[0] * outputs[1] * outputs[2]}"
  end

  def build_universe({:ok, tokens}) do
    Enum.reduce(tokens, {%{}, %{}}, fn
      [value, bot], {values, moves} ->
        {Map.put(values, bot, [value | Map.get(values, bot, [])]), moves}

      [source, low, high], {values, moves} ->
        {values, Map.put(moves, source, {low, high})}
    end)
  end

  def simulate_universe({bot_values, moves}) do
    simulate_universe({bot_values, %{}}, moves)
  end

  def simulate_universe({bot_values, outputs}, moves) do
    case Enum.find(bot_values, fn {_, values} -> length(values) == 2 end) do
      nil ->
        outputs

      {bot, values} ->
        {low_move, high_move} = moves[bot]
        [low_value, high_value] = sorted_values = Enum.sort(values)

        if sorted_values == @part_a_value_search do
          IO.puts "Part A: #{bot}"
        end

        {bot_values |> Map.drop([bot]), outputs}
        |> move(low_move, low_value)
        |> move(high_move, high_value)
        |> simulate_universe(moves)
    end
  end

  def move({bot_values, outputs}, {:bot, bot}, value) do
    {
      Map.put(bot_values, bot, [value | Map.get(bot_values, bot, [])]),
      outputs
    }
  end

  def move({bot_values, outputs}, {:output, slot}, value) do
    {
      bot_values,
      Map.put(outputs, slot, value)
    }
  end

  def parser do
    number = while(ASCII.digit, at_least: 1) |> bind(&String.to_integer/1)

    value_to_bot = [skip("value "), number, skip(" goes to bot "), number]

    destination = {
      one_of(["bot", "output"]) |> bind(&String.to_atom/1),
      number |> preceded_by(" ")
    }

    bot_gives = [
      skip("bot "),
      number,
      skip(" gives low to "),
      destination,
      skip(" and high to "),
      destination
    ]

    one_of([value_to_bot, bot_gives])
    |> line
    |> repeat
  end
end

Day10.run
