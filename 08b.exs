IO.read(:all)
|> String.strip
|> String.split("\n")
|> Enum.map(fn line ->
     cond do
       match = Regex.run(~r/^rect (\d+)x(\d+)$/, line) ->
         [_, x, y] = match
         {:rect, x, y}
       match = Regex.run(~r/^rotate row y=(\d+) by (\d+)$/, line) ->
         [_, y, count] = match
         {:roty, y, count}
       match = Regex.run(~r/^rotate column x=(\d+) by (\d+)$/, line) ->
         [_, x, count] = match
         {:rotx, x, count}
      true -> IO.puts(line)
     end
   end)
|> Enum.map(fn {a, b, c} -> {a, String.to_integer(b), String.to_integer(c)} end)
|> Enum.reduce(Tuple.duplicate(false, 300), fn command, screen ->
     case command do
       {:rect, x, y} ->
         Enum.reduce(for(px <- 0..x-1, py <- 0..y-1, do: py*50+px), screen, fn cell, screen -> put_elem(screen, cell, true) end)

       {:roty, y, count} ->
         Enum.reduce(1..count, screen, fn _, screen ->
           temp = elem(screen, y*50+49)
           Enum.reduce(49..1, screen, fn x, screen -> put_elem(screen, y*50+x, elem(screen, y*50+x-1)) end)
           |> put_elem(y*50, temp)
         end)

       {:rotx, x, count} ->
         Enum.reduce(1..count, screen, fn _, screen ->
           temp = elem(screen, 5*50+x)
           Enum.reduce(5..1, screen, fn y, screen -> put_elem(screen, y*50+x, elem(screen, (y-1)*50+x)) end)
           |> put_elem(x, temp)
         end)
     end
   end)
|> Tuple.to_list
|> Enum.map(fn a -> if a, do: "X", else: " " end)
|> Enum.chunk(50)
|> Enum.map(fn x -> Enum.join(x) end)
|> IO.inspect
