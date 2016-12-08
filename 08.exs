defmodule Day08 do
  @width 50
  @height 6

  def run do
    screen = build_screen

    screen
    |> Enum.filter(fn a -> a end)
    |> Enum.count
    |> IO.puts

    screen
    |> Enum.map(fn a -> if a, do: "X", else: " " end)
    |> Enum.chunk(@width)
    |> Enum.map(fn x -> Enum.join(x) end)
    |> IO.inspect
  end

  def build_screen do
    read_lines_from_stdin
    |> Enum.map(&parse_line/1)
    |> execute_commands
    |> Tuple.to_list
  end

  def read_lines_from_stdin do
    IO.read(:all)
    |> String.strip
    |> String.split("\n")
  end

  def parse_line(line) do
    cond do
      m = Regex.run(~r/^rect (\d+)x(\d+)$/, line)               -> extract_matches(:rect, m)
      m = Regex.run(~r/^rotate row y=(\d+) by (\d+)$/, line)    -> extract_matches(:roty, m)
      m = Regex.run(~r/^rotate column x=(\d+) by (\d+)$/, line) -> extract_matches(:rotx, m)
    end
  end

  def extract_matches(type, [_, a, b]) do
    {type, String.to_integer(a), String.to_integer(b)}
  end

  def execute_commands(commands) do
    Enum.reduce(commands, Tuple.duplicate(false, @width * @height), &execute_command/2)
  end

  def execute_command(command, screen) do
    case command do
      {:rect, x, y} ->
        cells = for px <- 0..x-1, py <- 0..y-1, do: pos(px, py)
        Enum.reduce(cells, screen, fn cell, screen -> put_elem(screen, cell, true) end)

      {:roty, y, count} ->
        Enum.reduce(1..count, screen, fn _, screen ->
          temp = elem screen, pos(-1, y)

          Enum.reduce((@width - 1)..1, screen, fn x, screen ->
            put_elem(screen, pos(x, y), elem(screen, pos(x - 1, y)))
          end)
          |> put_elem(pos(0, y), temp)
        end)

      {:rotx, x, count} ->
        Enum.reduce(1..count, screen, fn _, screen ->
          temp = elem screen, pos(x, -1)

          Enum.reduce((@height - 1)..1, screen, fn y, screen ->
            put_elem(screen, pos(x, y), elem(screen, pos(x, y - 1)))
          end)
          |> put_elem(pos(x, 0), temp)
        end)
    end
  end

  def pos(x, y) when x < 0, do: y * @width + x + @width
  def pos(x, y) when y < 0, do: (y + @height) * @width + x
  def pos(x, y), do: y * @width + x
end

Day08.run
