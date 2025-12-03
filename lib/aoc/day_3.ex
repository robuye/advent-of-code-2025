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
      bank
      |> Enum.with_index()
      |> Enum.reduce(0, fn {first_digit, idx}, acc ->
        last_digit =
          bank
          |> Enum.slice(idx + 1, length(bank))
          |> case do
            [] -> nil
            candidates -> Enum.max(candidates)
          end

        number =
          "#{first_digit}#{last_digit}"
          |> String.to_integer()

        if number > acc do
          number
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end
end
