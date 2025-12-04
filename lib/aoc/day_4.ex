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

    grid
    |> Enum.map(fn item ->
      count = check_neightbors(grid, item)

      item
      |> Map.put(:neightbors, count)
    end)
    |> Enum.filter(&(&1.chr == 1))
    |> Enum.filter(&(&1.neightbors < 4))
    |> Enum.count()
  end

  def part_2() do
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

    max_y = Enum.max_by(grid, & &1.y).y
    max_x = Enum.max_by(grid, & &1.x).x

    grid_as_map =
      grid
      |> Enum.map(fn item ->
        {{item.y, item.x}, item}
      end)
      |> Enum.into(%{})

    state = %{
      steps: 0,
      grid: grid_as_map,
      cursor: %{x: 0, y: 0},
      max_x: max_x,
      max_y: max_y,
      removed: 0
    }

    [0]
    |> Stream.cycle()
    |> Enum.reduce_while(state, fn _zero, state ->
      item =
        state.grid
        |> Map.get({state.cursor.y, state.cursor.x})

      neightbors = check_neightbors(state.grid, item)

      new_state =
        if item.chr == 1 and neightbors < 4 do
          # lift this paper roll and move cursor back
          new_grid =
            state.grid
            |> Map.update!({state.cursor.y, state.cursor.x}, &Map.put(&1, :chr, 0))

          # move the cursor back diagonally
          new_position = move_cursor_backward(state.cursor)

          state
          |> Map.update!(:steps, &(&1 + 1))
          |> Map.update!(:removed, &(&1 + 1))
          |> Map.put(:cursor, new_position)
          |> Map.put(:grid, new_grid)
        else
          # move forward by 1
          new_position = move_cursor_forward(state.cursor, state.max_x, state.max_y)

          state
          |> Map.update!(:steps, &(&1 + 1))
          |> Map.put(:cursor, new_position)
        end

      if new_state.cursor.x == nil or new_state.cursor.y == nil do
        {:halt, new_state}
      else
        {:cont, new_state}
      end
    end)
    |> Map.get(:removed)
  end

  defp move_cursor_forward(cursor, max_x, max_y) do
    new_x =
      cond do
        cursor.x == max_x and cursor.y == max_y -> nil
        cursor.x == max_x and cursor.y < max_y -> 0
        cursor.x < max_x -> cursor.x + 1
      end

    new_y =
      cond do
        cursor.x == max_x and cursor.y == max_y -> nil
        cursor.x == max_x and cursor.y < max_y -> cursor.y + 1
        cursor.x < max_x -> cursor.y
      end

    %{x: new_x, y: new_y}
  end

  defp move_cursor_backward(cursor) do
    new_x = if(cursor.x > 0, do: cursor.x - 1, else: 0)
    new_y = if(cursor.y > 0, do: cursor.y - 1, else: 0)

    %{x: new_x, y: new_y}
  end

  defp check_neightbors(grid, %{chr: 0}) when is_map(grid), do: 0

  defp check_neightbors(grid, item) when is_map(grid) do
    x = item.x
    y = item.y

    grid
    |> Map.take([
      {y - 1, x - 1},
      {y - 1, x},
      {y - 1, x + 1},
      {y + 1, x - 1},
      {y + 1, x},
      {y + 1, x + 1},
      {y, x - 1},
      {y, x + 1}
    ])
    |> Map.values()
    |> Enum.sum_by(& &1.chr)
  end

  defp check_neightbors(grid, item) do
    max_x = Enum.max_by(grid, & &1.x)
    max_y = Enum.max_by(grid, & &1.y)

    x1 = if(item.x == 0, do: 0, else: item.x - 1)
    x2 = if(item.x == max_x, do: item.x, else: item.x + 1)

    y1 = if(item.y == 0, do: 0, else: item.y - 1)
    y2 = if(item.y == max_y, do: item.y, else: item.y + 1)

    neightbors =
      grid
      |> Enum.filter(fn candidate ->
        candidate.x in x1..x2 and candidate.y in y1..y2
      end)
      |> Enum.sum_by(& &1.chr)

    neightbors - 1
  end

  defp print_grid(map) do
    # %{{y, x} => %{chr: 0|1}}

    {{max_x, _}, _} = Enum.max_by(map, fn {{x, _y}, _} -> x end)
    {{_, max_y}, _} = Enum.max_by(map, fn {{_x, y}, _} -> y end)

    IO.puts("")

    Enum.map(0..max_y, fn y ->
      Enum.reduce(0..max_x, "", fn x, acc ->
        chr = if(map[{y, x}].chr == 1, do: "@", else: ".")

        acc <> chr
      end)
    end)
    |> Enum.each(&IO.puts/1)

    IO.puts("")

    :ok
  end
end
