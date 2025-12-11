defmodule AOC.Day11 do
  # completes in ~ 0.002 seconds
  def part_1() do
    data =
      File.read!("data/day_11_1.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [name | outputs] =
          line
          |> String.replace(":", "")
          |> String.split(" ")

        {name, outputs}
      end)
      |> Enum.sort_by(fn {name, _} -> name end)
      |> Enum.into(%{})

    results =
      traverse(%{
        data: data,
        candidates: [["you"]],
        results: []
      })

    results.results
    |> length()
  end

  def traverse(state) when state.candidates == [], do: state

  def traverse(state) do
    [next_candidate | rest] = state.candidates
    [next_move | _] = next_candidate

    next_candidates =
      if next_move == "out" do
        rest
      else
        new_moves =
          state.data
          |> Map.get(next_move)
          |> Enum.map(fn move ->
            [move | next_candidate]
          end)

        new_moves ++ rest
      end

    next_results =
      if next_move == "out" do
        [
          Enum.reverse(next_candidate)
          | state.results
        ]
      else
        state.results
      end

    %{
      state
      | candidates: next_candidates,
        results: next_results
    }
    |> traverse()
  end
end
