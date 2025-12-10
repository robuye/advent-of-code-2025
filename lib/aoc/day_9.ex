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

  # this does not work
  def part_2() do
    data =
      File.read!("data/day_9_2.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&List.to_tuple/1)

    data_chr =
      data
      |> Enum.map(fn point -> {point, "#"} end)

    grid =
      data_chr
      |> then(&Enum.chunk_every(&1, 2, 1, &1))
      |> Enum.flat_map(fn [{p1, _}, {p2, _}] ->
        {x1, y1} = p1
        {x2, y2} = p2

        if x1 == x2 do
          y1..y2
          |> Enum.map(fn y -> {{x1, y}, "X"} end)
        else
          x1..x2
          |> Enum.map(fn x -> {{x, y1}, "X"} end)
        end
      end)

    grid
    |> Enum.into(%{})
    |> tap(fn _ -> IO.puts("4") end)
    |> then(fn g ->
      Enum.reduce(data_chr, g, fn {xy, chr}, acc ->
        Map.put(acc, xy, chr)
      end)
    end)

    Enum.chunk_every(data, 2, 1, data)
    |> Enum.take(1)
    |> Enum.reduce([], fn [p1, p2], acc ->
      {x1, y1} = p1
      {x2, y2} = p2

      {p1_candidates, p2_candidates} =
        if y1 == y2 do
          IO.puts("checking #{inspect(p1)} and #{inspect(p2)} (horizontal line)")

          p1_candidates =
            grid
            |> Enum.map(fn {xy, _} -> xy end)
            |> Enum.filter(fn {x, _} -> x == x1 end)
            |> Enum.sort_by(fn {_, y} -> y end)
            |> Enum.uniq()

          p2_candidates =
            grid
            |> Enum.map(fn {xy, _} -> xy end)
            |> Enum.filter(fn {x, _} -> x == x2 end)
            |> Enum.uniq()

          {p1_candidates, p2_candidates}
        else
          IO.puts("checking #{inspect(p1)} and #{inspect(p2)} (vertical line)")

          p1_candidates =
            grid
            |> Enum.map(fn {xy, _} -> xy end)
            |> Enum.filter(fn {_, y} -> y == y1 end)
            |> Enum.uniq()

          p2_candidates =
            grid
            |> Enum.map(fn {xy, _} -> xy end)
            |> Enum.filter(fn {_, y} -> y == y2 end)
            |> Enum.uniq()

          {p1_candidates, p2_candidates}
        end

      _replacements =
        Enum.flat_map(p1_candidates, fn p1 ->
          Enum.map(p2_candidates, fn p2 ->
            {p1, p2}
          end)
        end)
        |> IO.inspect(label: "replacements")

      acc
    end)
  end

  def calculate_area({x1, y1}, {x2, y2}) do
    Enum.product([
      abs(x1 - x2) + 1,
      abs(y1 - y2) + 1
    ])
  end
end
