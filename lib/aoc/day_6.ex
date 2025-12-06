defmodule AOC.Day6 do
  # completes in ~ 0.004 seconds
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

  # completes in ~ 0.13 seconds
  def part_2() do
    {ops_line, values} =
      File.read!("data/day_6_2.txt")
      |> String.split("\n", trim: true)
      |> List.pop_at(-1)

    column_sizes =
      ops_line
      |> String.split(~r|\S|, trim: true)
      |> Enum.map(&String.length/1)
      |> List.pop_at(-1)
      |> then(fn {last_op, rest} ->
        rest ++ [last_op + 1]
      end)

    values =
      values
      |> Enum.map(fn line ->
        column_sizes
        |> Enum.reduce({[], 0}, fn v, {results, position} ->
          num = String.slice(line, position, v)

          {results ++ [num], position + v + 1}
        end)
        |> elem(0)
      end)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(fn row ->
        row
        |> Enum.map(&String.split(&1, "", trim: true))
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(fn digits ->
          digits
          |> Enum.join()
          |> String.trim()
          |> String.to_integer()
        end)
      end)

    ops_line
    |> String.split(" ", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn
      {"+", idx} -> Enum.at(values, idx) |> Enum.sum()
      {"*", idx} -> Enum.at(values, idx) |> Enum.product()
    end)
    |> Enum.sum()
  end
end
