IO.read(:all)
  |> String.strip
  |> String.split(", ")
  |> Stream.map(fn command -> String.split_at(command, 1) end)
  |> Stream.map(fn {dir, len} -> {dir == "L", String.to_integer(len)} end)
  |> Stream.scan({0, -1, nil}, fn ({left, len}, {fx, fy, _}) ->
                   if left, do: {fy, -fx, len}, else: {-fy, fx, len}
                 end)
  |> Stream.scan([{0, 0}], fn ({fx, fy, len}, [{x, y} | _]) ->
                   for i <- len..1, do: {x + i * fx, y + i * fy}
                 end)
  |> Stream.flat_map(fn a -> a end)
  |> Stream.transform(MapSet.new([{0, 0}]), fn (position, set) ->
                        {
                          if(MapSet.member?(set, position), do: [position], else: []),
                          MapSet.put(set, position)
                        }
                      end)
  |> Enum.take(1)
  |> (fn [{x, y}] -> abs(x) + abs(y) end).()
  |> IO.inspect
