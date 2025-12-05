defmodule AOC.Day5 do
  # completes in ~ 0.006 seconds
  def part_1() do
    [ranges, values] =
      File.read!("data/day_5_1.txt")
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn half ->
        half
        |> String.split("\n", trim: true)
      end)

    ranges =
      ranges
      |> Enum.map(fn r ->
        [first, last] = String.split(r, "-")

        Range.new(
          String.to_integer(first),
          String.to_integer(last)
        )
      end)

    values =
      values
      |> Enum.map(&String.to_integer/1)

    Enum.reduce(values, 0, fn value, acc ->
      if Enum.any?(ranges, &(value in &1)) do
        acc + 1
      else
        acc
      end
    end)
  end

  # completes in ~ 0.000937 seconds
  def part_2() do
    [ranges, _values] =
      File.read!("data/day_5_2.txt")
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn half ->
        half
        |> String.split("\n", trim: true)
      end)

    ranges =
      ranges
      |> Enum.map(fn r ->
        [first, last] = String.split(r, "-")

        Range.new(
          String.to_integer(first),
          String.to_integer(last)
        )
      end)
      |> Enum.sort_by(& &1.first, :asc)

    %{visited: new_ranges} =
      bfs(%{
        candidates: ranges,
        visited: []
      })

    new_ranges
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end

  def bfs(state) when state.candidates == [] do
    state
  end

  def bfs(state) do
    {next_candidate, leftover_candidates} = List.pop_at(state.candidates, 0)

    overlaping = Enum.find(state.visited, fn x -> not Range.disjoint?(next_candidate, x) end)
    overlaping_idx = Enum.find_index(state.visited, &(&1 == overlaping))

    {next_visited, next_candidates} =
      if overlaping do
        merged_range = merge_ranges(next_candidate, overlaping)

        next_candidates =
          with true <- overlaping_idx > 0,
               previous <- Enum.at(state.candidates, overlaping_idx - 1),
               true <- previous.last >= overlaping.first do
            # requeue previous range if it overlaps after merge
            [previous | leftover_candidates]
          else
            _ -> leftover_candidates
          end

        next_visited = List.replace_at(state.visited, overlaping_idx, merged_range)

        {next_visited, next_candidates}
      else
        next_visited = [next_candidate | state.visited]

        {next_visited, leftover_candidates}
      end

    bfs(%{
      visited: next_visited,
      candidates: next_candidates
    })
  end

  defp merge_ranges(r1, r2) do
    next_first =
      if r1.first < r2.first do
        r1.first
      else
        r2.first
      end

    next_last =
      if r1.last > r2.last do
        r1.last
      else
        r2.last
      end

    Range.new(next_first, next_last)
  end
end
