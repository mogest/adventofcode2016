Stream.iterate(1, fn a -> a + 1 end)
|> Stream.map(fn number -> :crypto.hash(:md5, "abbhdwsy#{number}") |> Base.encode16 end)
|> Stream.filter(fn hash -> String.slice(hash, 0..4) == "00000" end)
|> Stream.map(fn hash -> String.slice(hash, 5..6) |> String.graphemes end)
|> Stream.map(fn [position, letter] -> {String.to_integer(position, 16), letter} end)
|> Enum.reduce_while(Tuple.duplicate(nil, 8), fn ({position, letter}, code) ->
     cond do
       Enum.all?(Tuple.to_list(code))       -> {:halt, code}
       position > 7 || elem(code, position) -> {:cont, code}
       true                                 -> {:cont, put_elem(code, position, letter)}
     end
   end)
|> Tuple.to_list
|> Enum.join
|> IO.puts
