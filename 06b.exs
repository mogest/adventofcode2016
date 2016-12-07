IO.read(:all)
|> String.strip
|> String.split("\n")
|> Enum.map(&String.graphemes/1)
|> List.zip
|> Enum.map(&Tuple.to_list/1)
|> Enum.map(fn set ->
     Enum.reduce(set, %{}, fn input, map ->
       Map.update(map, input, 0, &(&1 + 1))
     end)
   end)
|> Enum.map(fn occurences ->
     Enum.min_by(occurences, &elem(&1, 1))
     |> elem(0)
   end)
|> Enum.join
|> IO.puts
