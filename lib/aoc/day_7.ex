defmodule AOC.Day7 do
  # completes in ~ 0.5 seconds
  def part_1() do
    grid =
      File.read!("data/day_7_1.txt")
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {chr, x} ->
          {{x, y}, chr}
        end)
        |> Enum.reject(fn {_, chr} -> chr == "." end)
      end)
      |> Enum.into(%{})

    max_y =
      Map.keys(grid)
      |> Enum.max_by(fn {_, y} -> y end)
      |> elem(1)

    start_at =
      grid
      |> Enum.find(fn {_, chr} -> chr == "S" end)
      |> elem(0)

    traverse(%{
      grid: grid,
      candidates: [start_at],
      visited: [],
      max_y: max_y,
      splits: 0
    })
    |> Map.get(:splits)
  end

  # completes in ~ 0.05 seconds
  def part_2() do
    grid =
      File.read!("data/day_7_2.txt")
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {chr, x} ->
          {{x, y}, chr}
        end)
        |> Enum.reject(fn {_, chr} -> chr == "." end)
      end)
      |> Enum.into(%{})

    max_y =
      Map.keys(grid)
      |> Enum.max_by(fn {_, y} -> y end)
      |> elem(1)

    {start_x, start_y} =
      grid
      |> Enum.find(fn {_, chr} -> chr == "S" end)
      |> elem(0)

    results =
      quantum_traverse(%{
        grid: grid,
        candidates: [{start_x, start_y + 1}],
        visited: %{
          {start_x, start_y} => 1
        },
        max_y: max_y
      })

    results.visited
    |> Enum.map(fn
      {{_, ^max_y}, v} -> v
      _ -> 0
    end)
    |> Enum.sum()
  end

  def traverse(state) when state.candidates == [] do
    state
  end

  def traverse(state) do
    [current_move | leftover] = state.candidates

    {x, y} = current_move
    chr = Map.get(state.grid, current_move)

    if chr == "^" do
      next_visited = [current_move | state.visited]

      next_candidates =
        [{x - 1, y + 1}, {x + 1, y + 1} | leftover]
        |> Enum.filter(fn {_, y} -> y <= state.max_y end)
        |> Enum.filter(&(&1 not in state.visited))

      next_state = %{
        state
        | visited: next_visited,
          candidates: next_candidates,
          splits: state.splits + 1
      }

      traverse(next_state)
    else
      next_candidates =
        [{x, y + 1} | leftover]
        |> Enum.filter(fn {_, y} -> y <= state.max_y end)
        |> Enum.filter(&(&1 not in state.visited))

      traverse(%{state | candidates: next_candidates})
    end
  end

  def quantum_traverse(state) when state.candidates == [] do
    state
  end

  def quantum_traverse(state) do
    [current_move | leftover] = state.candidates

    {x, y} = current_move
    chr = Map.get(state.grid, current_move)

    parent_score = Map.get(state.visited, {x, y - 1}, 0)

    if chr == "^" do
      next_candidates =
        (leftover ++ [{x - 1, y + 1}, {x + 1, y + 1}])
        |> Enum.uniq()

      left_parent_score = Map.get(state.visited, {x - 1, y - 1}, 0)
      right_parent_score = Map.get(state.visited, {x + 1, y - 1}, 0)

      next_visited =
        state.visited
        |> Map.put_new({x - 1, y}, left_parent_score)
        |> Map.put_new({x + 1, y}, right_parent_score)
        |> Map.update!({x - 1, y}, &(&1 + parent_score))
        |> Map.update!({x + 1, y}, &(&1 + parent_score))

      quantum_traverse(%{
        state
        | candidates: next_candidates,
          visited: next_visited
      })
    else
      next_visited =
        state.visited
        |> Map.put_new({x, y}, parent_score)

      next_candidates =
        (leftover ++ [{x, y + 1}])
        |> Enum.filter(fn {_, y} -> y <= state.max_y end)

      quantum_traverse(%{
        state
        | visited: next_visited,
          candidates: next_candidates
      })
    end
  end
end
