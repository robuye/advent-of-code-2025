defmodule AOC.Day1 do
  def part_1() do
    File.read!("data/day_1_1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "R" <> num -> {:r, String.to_integer(num)}
      "L" <> num -> {:l, String.to_integer(num)}
    end)
    |> Enum.map(fn
      {d, n} when n <= 99 -> {d, n}
      {d, n} when n > 99 -> {d, Integer.mod(n, 100)}
    end)
    |> Enum.reduce({50, 0}, fn {d, n}, {acc, password} ->
      case {d, n} do
        {:l, n} ->
          move_to = acc - n

          new_position =
            if move_to < 0 do
              100 + move_to
            else
              move_to
            end

          new_password =
            if new_position == 0 do
              password + 1
            else
              password
            end

          {new_position, new_password}

        {:r, n} ->
          move_to = acc + n

          new_position =
            if move_to > 99 do
              move_to - 100
            else
              move_to
            end

          new_password =
            if new_position == 0 do
              password + 1
            else
              password
            end

          {new_position, new_password}
      end
    end)
    |> elem(1)
  end

  def part_2() do
    File.read!("data/day_1_2.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "R" <> num -> {:r, String.to_integer(num)}
      "L" <> num -> {:l, String.to_integer(num)}
    end)
    |> Enum.map(fn
      {d, n} when n < 100 ->
        {d, n, 0}

      {d, n} when n >= 100 ->
        rounds = Kernel.div(n, 100)

        {d, Integer.mod(n, 100), rounds}
    end)
    |> Enum.reduce({50, 0}, fn {d, n, r}, {acc, password} ->
      case {d, n} do
        {:l, n} ->
          move_to = acc - n

          {seen_zeros, new_position} =
            case move_to do
              x when acc == 0 and x < 0 -> {r, 100 + move_to}
              x when x < 0 -> {r + 1, 100 + move_to}
              _ -> {r, move_to}
            end

          new_password =
            if new_position == 0 do
              password + seen_zeros + 1
            else
              password + seen_zeros
            end

          {new_position, new_password}

        {:r, n} ->
          move_to =
            acc + n

          {seen_zeros, new_position} =
            case move_to do
              x when x == 100 -> {r, move_to - 100}
              x when x > 99 -> {r + 1, move_to - 100}
              _ -> {r, move_to}
            end

          new_password =
            if new_position == 0 do
              password + seen_zeros + 1
            else
              password + seen_zeros
            end

          {new_position, new_password}
      end
    end)
    |> elem(1)
  end
end
