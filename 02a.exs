IO.read(:all)
|> String.strip
|> String.split("\n")
|> Enum.map(fn sequence -> String.graphemes(sequence) end)
|> Enum.scan("5", fn (sequence, number) ->
     Enum.reduce(sequence, number, fn (instruction, number) ->
       %{"U" => "123123456", "D" => "456789789", "L" => "112445778", "R" => "233566899"}
       |> Map.get(instruction)
       |> String.at(String.to_integer(number) - 1)
     end)
   end)
|> Enum.join
|> IO.puts
