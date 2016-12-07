IO.read(:all)
|> String.strip
|> String.split("\n")
|> Enum.map(fn address ->
     [
       Regex.scan(~r/\[\w+\]/, address) |> List.flatten |> Enum.join(" "),
       String.split(address, ~r/\[\w+\]/) |> Enum.join(" ")
     ]
     |> Enum.map(fn part ->
          Regex.scan(~r/(.)(.)\2\1/, part)
          |> Enum.filter(fn [_, b, a] -> a != b end)
          |> Enum.any?
        end)
   end)
|> Enum.filter(fn [inside, outside] -> outside && !inside end)
|> Enum.count
|> IO.inspect
