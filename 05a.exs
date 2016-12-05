Stream.iterate(1, fn a -> a + 1 end)
|> Stream.map(fn number -> :crypto.hash(:md5, "abbhdwsy#{number}") |> Base.encode16 end)
|> Stream.filter(fn hash -> String.slice(hash, 0..4) == "00000" end)
|> Enum.take(8)
|> Enum.map(fn hash -> String.slice(hash, 5..5) end)
|> Enum.join
|> IO.puts
