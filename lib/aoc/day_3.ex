defmodule AOC.Day3 do
  def part_1() do
    File.read!("data/day_3_1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn bank ->
      get_digits(bank, 2, [])
      |> Enum.map(&Integer.to_string/1)
      |> Enum.join("")
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def part_2() do
    File.read!("data/day_3_2.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn bank ->
      get_digits(bank, 12, [])
      |> Enum.map(&Integer.to_string/1)
      |> Enum.join("")
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def get_digits(_candidates, 0, accumulator) do
    accumulator
  end

  def get_digits(candidates, count, accumulator) do
    valid_candidates =
      Enum.slice(candidates, 0, length(candidates) - count + 1)

    next_digit = Enum.max(valid_candidates)
    next_idx = Enum.find_index(valid_candidates, &(&1 == next_digit))

    next_candidates =
      candidates
      |> Enum.slice(next_idx + 1, length(candidates))

    get_digits(next_candidates, count - 1, accumulator ++ [next_digit])
  end
end
