defmodule AOC.Day7 do
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
end
