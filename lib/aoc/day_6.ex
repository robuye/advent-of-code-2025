defmodule AOC.Day6 do
  def part_1() do
    File.read!("data/day_6_1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(~r|\s+|, trim: true)
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn row ->
      {op, str_values} = List.pop_at(row, -1)

      values = Enum.map(str_values, &String.to_integer/1)

      {op, values}
    end)
    |> Enum.map(fn
      {"+", values} -> Enum.sum(values)
      {"*", values} -> Enum.product(values)
    end)
    |> Enum.sum()
  end
end
