# OK, I've given up on the single statement thing.  Too painful for this challenge.

defmodule Day07 do
  def run do
    read_lines_from_stdin
    |> Enum.filter(&supports_ssl?/1)
    |> Enum.count
    |> IO.puts
  end

  def read_lines_from_stdin do
    IO.read(:all)
    |> String.strip
    |> String.split("\n")
  end

  def supports_ssl?(address) do
    {supernet, hypernet} = split_address(address)

    supports_ssl?(supernet, hypernet)
  end

  def supports_ssl?([a, b, a | _] = [_ | tail], hypernet) when a != b do
    matching_bab?(a, b, hypernet) || supports_ssl?(tail, hypernet)
  end

  def supports_ssl?([_ | tail], hypernet), do: supports_ssl?(tail, hypernet)
  def supports_ssl?([], _),                do: false

  def matching_bab?(a, b, hypernet) do
    String.contains?(hypernet, b <> a <> b)
  end

  def split_address(address) do
    split_address(String.graphemes(address), [], [])
  end

  def split_address([], supernet, hypernet) do
    {supernet, hypernet |> Enum.join}
  end

  def split_address([letter | tail], part_a, part_b) do
    if letter in ~w([ ]) do
      split_address(tail, [letter | part_b], part_a)
    else
      split_address(tail, [letter | part_a], part_b)
    end
  end
end

Day07.run
