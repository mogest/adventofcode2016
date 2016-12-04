IO.read(:all)
|> String.strip
|> String.split("\n")
|> Enum.map(fn line -> Regex.run(~r/^([a-z-]+)-(\d+)\[(\w+)\]$/, line) |> tl end)
|> Enum.map(fn [name, sector, _] -> {String.replace(name, "-", "") |> String.graphemes, sector} end)
|> Enum.map(fn {name, sector} ->
     {Enum.map(name, fn char ->
       <<rem(hd(to_charlist(char)) - 97 + String.to_integer(sector), 26) + 97>>
       |> to_string
     end)
     |> Enum.join, sector}
   end)
|> Enum.filter(fn {name, _} -> String.contains?(name, "northpole") end)
|> IO.inspect
