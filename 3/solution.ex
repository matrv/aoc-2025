file = File.read!("input.txt")

charlists =
  String.split(file, "\n")
  |> Enum.filter(fn line -> line != "" end)
  |> Enum.map(fn line ->
    String.to_charlist(line)
  end)

answer1 =
  charlists
  |> Enum.map(fn charlist ->
    for h <- 0..(length(charlist) - 2),
        v <- (h + 1)..(length(charlist) - 1) do
      {Enum.at(charlist, h) - ?0, Enum.at(charlist, v) - ?0}
    end
  end)
  |> Enum.map(fn list ->
    Enum.map(list, fn {a, b} -> a * 10 + b end) |> Enum.max()
  end)
  |> Enum.sum()

IO.puts("Part 1 answer: #{answer1}")

defmodule Aoc do
  def calculate(charlist, start, iter, res) do
    {a, b} =
      Enum.map(start..(length(charlist) - (12 - iter)), fn a1 ->
        {
          Enum.at(charlist, a1) - ?0,
          a1
        }
      end)
      |> Enum.max_by(fn {a, _} -> a end)

    if iter == 11 do
      res * 10 + a
    else
      calculate(charlist, b + 1, iter + 1, res * 10 + a)
    end
  end
end

answer2 =
  charlists
  |> Enum.map(fn charlist ->
    Aoc.calculate(charlist, 0, 0, 0)
  end)
  |> Enum.sum()

IO.puts("Part 2 answer: #{answer2}")
