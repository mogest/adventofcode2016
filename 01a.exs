IO.read(:all)
  |> String.strip
  |> String.split(", ")
  |> Enum.map(fn command -> String.split_at(command, 1) end)
  |> Enum.map(fn {dir, len} -> {dir == "L", String.to_integer(len)} end)
  |> Enum.scan({0, -1, nil}, fn ({left, len}, {fx, fy, _}) -> if left do {fy, -fx, len} else {-fy, fx, len} end end)
  |> Enum.reduce({0, 0}, fn ({fx, fy, len}, {x, y}) -> {x + len * fx, y + len * fy} end)
  |> (fn {x, y} -> abs(x) + abs(y) end).()
  |> IO.inspect
