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
    {outside, inside} = split_address(address)

    supports_ssl?(outside, inside)
  end

  def supports_ssl?([a, b, a | _] = [_ | tail], inside) do
    matching_bab?(a, b, inside) || supports_ssl?(tail, inside)
  end

  def supports_ssl?([_ | tail], inside) do
    supports_ssl?(tail, inside)
  end

  def supports_ssl?([], _) do
    false
  end

  def matching_bab?(a, b, inside) do
    a != b && String.contains?(inside, b <> a <> b)
  end

  def split_address(address) do
    {
      String.split(address, hypernet_regex) |> Enum.join(" ") |> String.graphemes,
      Regex.scan(hypernet_regex, address) |> List.flatten |> Enum.join(" ")
    }
  end

  def hypernet_regex do
    ~r/\[\w+\]/
  end
end

Day07.run
