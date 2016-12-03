IO.read(:all)
|> String.strip
|> String.split("\n")
|> Enum.map(fn line -> 
     line
     |> String.strip
     |> String.split(~r/\s+/)
     |> Enum.map(&String.to_integer/1)
     |> Enum.sort
   end)
|> Enum.count(fn [a, b, c] -> a + b > c end)
|> IO.puts
