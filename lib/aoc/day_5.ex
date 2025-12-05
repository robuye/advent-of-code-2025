defmodule AOC.Day5 do
  def part_1() do
    [ranges, values] =
      File.read!("data/day_5_1.txt")
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn half ->
        half
        |> String.split("\n", trim: true)
      end)

    ranges =
      ranges
      |> Enum.map(fn r ->
        [first, last] = String.split(r, "-")

        Range.new(
          String.to_integer(first),
          String.to_integer(last)
        )
      end)

    values =
      values
      |> Enum.map(&String.to_integer/1)

    Enum.reduce(values, 0, fn value, acc ->
      if Enum.any?(ranges, &(value in &1)) do
        acc + 1
      else
        acc
      end
    end)
  end
end
