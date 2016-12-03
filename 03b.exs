IO.read(:all)
|> String.strip
|> String.split("\n")
|> Enum.map(fn line ->
     line
     |> String.strip
     |> String.split(~r/\s+/)
     |> Enum.map(&String.to_integer/1)
   end)
|> List.zip
|> Enum.map(&Tuple.to_list/1)
|> List.flatten
|> Enum.chunk(3)
|> Enum.map(&Enum.sort/1)
|> Enum.count(fn [a, b, c] -> a + b > c end)
|> IO.puts
