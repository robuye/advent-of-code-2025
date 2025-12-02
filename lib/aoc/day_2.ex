require Integer

defmodule AOC.Day2 do
  def part_1() do
    File.read!("data/day_2_1.txt")
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn str ->
      str
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.flat_map(fn {lhs, rhs} ->
      Range.new(lhs, rhs)
      |> Enum.reduce([], fn n, acc ->
        if digits_repeat_once(n) do
          [n | acc]
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end

  def part_2() do
    File.read!("data/day_2_1.txt")
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn str ->
      str
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.flat_map(fn {lhs, rhs} ->
      Range.new(lhs, rhs)
      |> Enum.reduce([], fn n, acc ->
        if digits_repeat_at_least_once(n) do
          acc ++ [n]
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end

  def digits_repeat_at_least_once(n) when n < 10, do: false

  def digits_repeat_at_least_once(n) do
    digits = Integer.digits(n)
    pattern_length = Integer.floor_div(length(digits), 2)

    1..pattern_length
    |> Enum.reduce_while([], fn len, acc ->
      parts = Enum.chunk_every(digits, len)

      if Enum.all?(parts, &(&1 == hd(parts))) do
        {:halt, [hd(parts) | acc]}
      else
        {:cont, acc}
      end
    end)
    |> Enum.any?()
  end

  def digits_repeat_once(n) do
    digits = Integer.digits(n)

    if Integer.is_even(length(digits)) do
      pattern_length = Integer.floor_div(length(digits), 2)

      [lhs, rhs] =
        digits
        |> Enum.chunk_every(pattern_length)

      lhs == rhs
    else
      false
    end
  end
end
