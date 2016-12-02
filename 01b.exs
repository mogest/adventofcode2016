IO.read(:all)
  |> String.strip
  |> String.split(", ")
  |> Enum.map(fn command -> String.split_at(command, 1) end)
  |> Enum.map(fn {dir, len} -> {dir == "L", String.to_integer(len)} end)
  |> Enum.scan({0, -1, nil}, fn ({left, len}, {fx, fy, _}) ->
                 if left do {fy, -fx, len} else {-fy, fx, len} end
               end)
  |> Enum.scan([{0, 0}], fn ({fx, fy, len}, [{x, y} | _]) ->
                 for i <- len..1 do {x + i * fx, y + i * fy} end
               end)
  |> List.flatten
  |> Enum.reduce_while(MapSet.new([{0, 0}]), fn (position, set) ->
                         if MapSet.member?(set, position) do
                           {:halt, position}
                         else
                           {:cont, MapSet.put(set, position)}
                         end
                       end)
  |> (fn {x, y} -> abs(x) + abs(y) end).()
  |> IO.inspect
