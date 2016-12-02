IO.read(:all)
|> String.strip
|> String.split("\n")
|> Enum.map(fn sequence -> String.graphemes(sequence) end)
|> Enum.scan("5", fn (sequence, number) ->
     Enum.reduce(sequence, number, fn (instruction, number) ->
       %{"U" => "121452349678B", "D" => "36785ABC9ADCD", "L" => "122355678AABD", "R" => "134467899BCCD"}
       |> Map.get(instruction)
       |> String.at(String.to_integer(number, 16) - 1)
     end)
   end)
|> Enum.join
|> IO.puts
