defmodule AOC.Day9 do
  # completes in ~ 0.09 seconds
  def part_1() do
    data =
      File.read!("data/day_9_1.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&List.to_tuple/1)

    data
    |> Enum.flat_map(fn point1 ->
      data
      |> Enum.reject(&(&1 == point1))
      |> Enum.map(fn point2 ->
        {point1, point2, calculate_area(point1, point2)}
      end)
    end)
    |> Enum.sort_by(fn {_, _, area} -> area end, :desc)
    |> Enum.at(0)
    |> elem(2)
  end

  def calculate_area({x1, y1}, {x2, y2}) do
    Enum.product([
      abs(x1 - x2) + 1,
      abs(y1 - y2) + 1
    ])
  end
end
