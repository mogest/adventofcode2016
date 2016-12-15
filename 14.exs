defmodule Day14 do
  @salt "ngcjuoqr"
  @rounds 2017 # 1 for part A, 2017 for part B
  @key_number 64
  @window_size 1000

  def run do
    Stream.iterate(0, fn index -> index + 1 end)
    |> Stream.map(&hash_builder/1)
    |> Stream.transform([], &filter_valid_keys/2)
    |> Stream.transform([], &stream_sorter/2)
    |> Enum.at(@key_number - 1)
    |> IO.inspect
  end

  def hash_builder(index) do
    {
      index,
      perform_hash("#{@salt}#{index}", @rounds)
    }
  end

  def perform_hash(text, 0), do: text

  def perform_hash(text, rounds) do
    :crypto.hash(:md5, text)
    |> Base.encode16(case: :lower)
    |> perform_hash(rounds - 1)
  end

  def filter_valid_keys({index, hash}, candidates) do
    {new_candidates, accepted} = detect_candidate_acceptance(hash, candidates)

    case Regex.run(~r/(.)\1\1/, hash) do
      [_, digit] -> {accepted, [{index, String.duplicate(digit, 5), @window_size} | new_candidates]}
      nil        -> {accepted, new_candidates}
    end
  end

  def detect_candidate_acceptance(hash, candidates) do
    Enum.flat_map_reduce(candidates, [], fn {index, digits, ttl}, accepted ->
      cond do
        String.contains?(hash, digits) -> {[], [index | accepted]}
        ttl > 1                        -> {[{index, digits, ttl - 1}], accepted}
        true                           -> {[], accepted}
      end
    end)
  end

  def stream_sorter(index, queue) do
    new_queue = [index | queue] |> Enum.sort

    cutoff = Enum.max(new_queue) - @window_size

    Enum.partition(new_queue, & &1 < cutoff)
  end
end

Day14.run
