defmodule AOC.Day12 do
  # completes in ~ ?? seconds
  # not completed :(
  def part_1() do
    %{regions: regions, shapes: shapes} =
      File.read!("data/day_12_1.txt")
      |> String.split("\n\n", trim: true)
      |> Enum.reduce(%{shapes: [], regions: []}, fn block, acc ->
        if String.match?(block, ~r|^\d+:|) do
          [_idx | shape] = String.split(block, "\n", trim: true)

          %{acc | shapes: acc.shapes ++ [shape]}
        else
          regions =
            block
            |> String.split("\n", trim: true)
            |> Enum.map(fn line ->
              [area, shapes] =
                String.split(line, ":", trim: true, parts: 2)

              [rows, cols] =
                area
                |> String.split("x")
                |> Enum.map(&String.to_integer/1)

              shapes =
                shapes
                |> String.split(" ", trim: true)
                |> Enum.map(&String.to_integer/1)

              {{rows, cols}, shapes}
            end)
            |> Enum.into(%{})

          %{acc | regions: regions}
        end
      end)

    regions
    |> Enum.map(fn {{max_y, max_x}, shapes_to_stack} ->
      grid =
        0..max_y
        |> Enum.flat_map(fn y ->
          0..max_x
          |> Enum.map(fn x ->
            {{y, x}, 0}
          end)
        end)
        |> Enum.into(%{})

      shapes =
        shapes_to_stack
        |> Enum.with_index()
        |> Enum.filter(fn {count, _idx} -> count > 0 end)
        |> Enum.flat_map(fn {count, idx} ->
          1..count
          |> Enum.map(fn _ -> Enum.at(shapes, idx) end)
        end)

      state =
        %{
          cursor: {0, 0},
          grid: grid,
          shapes: shapes
        }
        |> traverse()
    end)
    |> Enum.at(0)
  end

  def traverse(state) do
    [next_shape | rest] = state.shapes

    if fits?(state.grid, state.cursor, next_shape) do
    end
  end

  def fits?(grid, cursor, shape) do
    {cy, cx} = cursor

    shape_coordinates =
      shape
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {chr, x} ->
          {{y, x}, if(chr == "#", do: 1, else: 0)}
        end)
        |> Enum.into(%{})
      end)

    # coordinates
    # |> Enum.all?(fn {{y1, x1}, on_off} ->
    # end)

    IO.inspect(shape_coordinates)
  end
end
