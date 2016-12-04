IO.read(:all)
|> String.strip
|> String.split("\n")
|> Enum.map(fn line -> Regex.run(~r/^([a-z-]+)-(\d+)\[(\w+)\]$/, line) |> tl end)
|> Enum.map(fn [name, sector, checksum] -> {String.replace(name, "-", "") |> String.graphemes, sector, checksum} end)
|> Enum.map(fn {name, sector, checksum} ->
     {Enum.reduce(name, %{}, fn (letter, map) -> Map.put(map, letter, (Map.get(map, letter) || 0) + 1) end), sector, checksum}
   end)
|> Enum.map(fn {freq, sector, checksum} ->
     {Enum.sort_by(freq, fn {k, v} -> -v * 1000 + hd(to_charlist(k)) end) |> Enum.take(5) |> Enum.map(&elem(&1, 0)) |> Enum.join,
      sector,
      checksum}
   end)
|> Enum.filter(fn {computed, sector, checksum} -> computed == checksum end)
|> Enum.reduce(0, fn ({computed, sector, checksum}, acc) -> acc + String.to_integer(sector) end)
|> IO.inspect
