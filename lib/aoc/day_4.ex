defmodule AOC.Day4 do
  def part_1() do
    grid =
      File.read!("data/day_4_1.txt")
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {chr, x} ->
          v = if(chr == "@", do: 1, else: 0)
          %{x: x, y: y, chr: v}
        end)
      end)

    max_y = Enum.max_by(grid, & &1.y)
    max_x = Enum.max_by(grid, & &1.x)

    grid
    |> Enum.map(fn item ->
      x1 = if(item.x == 0, do: 0, else: item.x - 1)
      x2 = if(item.x == max_x, do: item.x, else: item.x + 1)

      y1 = if(item.y == 0, do: 0, else: item.y - 1)
      y2 = if(item.y == max_y, do: item.y, else: item.y + 1)

      neightboors =
        grid
        |> Enum.filter(fn candidate ->
          candidate.x in x1..x2 and candidate.y in y1..y2
        end)
        |> Enum.sum_by(& &1.chr)

      item
      |> Map.put(:neightboors, neightboors - 1)
    end)
    |> Enum.filter(&(&1.chr == 1))
    |> Enum.filter(&(&1.neightboors < 4))
    |> Enum.count()
  end
end
