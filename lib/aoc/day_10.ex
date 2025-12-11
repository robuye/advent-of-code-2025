defmodule AOC.Day10 do
  # completes in ~ ?? seconds
  # todo: it never completes
  def part_1() do
    data =
      File.read!("data/day_10_1.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(" ", trim: true)
        |> Enum.reduce(%{}, fn item, acc ->
          case item do
            "[" <> _rest ->
              item
              |> String.replace(["[", "]"], "")
              |> String.graphemes()
              |> Enum.map(fn
                "#" -> "1"
                "." -> "0"
              end)
              |> Enum.join()
              |> then(fn this ->
                acc
                |> Map.put(:lights, this)
                |> Map.put(:lights_v2, Integer.parse(this, 2) |> elem(0))
              end)

            "(" <> _rest ->
              item
              |> String.replace(["(", ")"], "")
              |> String.graphemes()
              |> Enum.flat_map(fn s ->
                String.split(s, ",", trim: true)
                |> Enum.map(&String.to_integer/1)
              end)
              |> then(fn this ->
                initial_mask =
                  acc.lights
                  |> String.graphemes()
                  |> Enum.map(fn _ -> 0 end)

                mask =
                  this
                  |> Enum.reduce(initial_mask, fn position, acc ->
                    List.replace_at(acc, position, 1)
                  end)
                  |> Enum.join("")

                {mask_v2, _} = Integer.parse(mask, 2)

                acc
                |> Map.update(:buttons, [this], &[this | &1])
                |> Map.update(:masks, [mask], &[mask | &1])
                |> Map.update(:buttons_v2, [mask_v2], &[mask_v2 | &1])
              end)

            "{" <> _rest ->
              item
              |> String.replace(["{", "}"], "")
              |> String.graphemes()
              |> Enum.flat_map(fn s ->
                String.split(s, ",", trim: true)
                |> Enum.map(&String.to_integer/1)
              end)
              |> then(fn this -> Map.put(acc, :joltages, this) end)
          end
        end)
      end)

    data
    |> Enum.with_index()
    |> Enum.map(fn {row, idx} ->
      IO.puts(idx)

      row.buttons_v2
      |> Enum.map(&[&1])
      |> push_buttons(row.lights_v2, row.buttons_v2)
    end)

    # |> Enum.sum()
  end

  def push_buttons(candidates, expected, buttons) do
    [next_moves | rest] = candidates

    new_lights =
      next_moves
      |> Enum.reduce(0, fn bitmask, acc ->
        Bitwise.bxor(acc, bitmask)
      end)

    if new_lights == expected do
      length(next_moves)
    else
      ## IO.inspect(next_moves, charlists: :as_lists, label: "next moves")

      new_moves =
        buttons
        |> Enum.reject(&Enum.member?(next_moves, &1))
        |> Enum.map(fn b -> next_moves ++ [b] end)

      # |> IO.inspect(charlists: :as_lists, label: "new moves")

      next_candidates = rest ++ new_moves

      push_buttons(next_candidates, expected, buttons)
    end
  end
end
