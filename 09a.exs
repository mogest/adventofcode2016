defmodule Day09a do
  def run do
    {output, _, _, _, _} = parse

    IO.puts String.length(output)
  end

  def parse do
    IO.read(:all)
    |> String.strip
    |> String.graphemes
    |> Enum.reduce({"", nil, nil, nil, nil}, fn char, {output, command, repeat, len, times} ->
         cond do
           len && len > 1 ->
             {output, nil, repeat <> char, len - 1, times}

           len ->
             {output <> multiply_string(repeat <> char, times), nil, nil, nil, nil}

           command && char == ")" ->
             {len, times} = parse_command(command)
             {output, nil, "", len, times}

           command ->
             {output, command <> char, nil, nil, nil}

           char == "(" ->
             {output, "", nil, nil, nil}

           true ->
             {output <> char, nil, nil, nil, nil}
         end
       end)
  end

  def parse_command(command) do
    [_, len, times] = Regex.run(~r/^(\d+)x(\d+)$/, command)
    {String.to_integer(len), String.to_integer(times)}
  end

  def multiply_string(string, times) do
    Enum.map(1..times, fn _ -> string end)
    |> Enum.join
  end
end

Day09a.run
