defmodule AOC.Day8 do
  # completes in ~ 0.9 seconds
  def part_1() do
    File.read!("data/day_8_1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
    |> get_shortest_connections()
    |> Enum.take(1000)
    |> Enum.reduce([], fn {p1, p2, _}, circuits ->
      Enum.filter(circuits, fn cir -> p1 in cir or p2 in cir end)
      |> case do
        [] ->
          [[p1, p2] | circuits]

        [c1] ->
          circuits
          |> Enum.map(fn
            ^c1 -> [p1, p2 | c1] |> Enum.uniq()
            cir -> cir
          end)

        [c1, c2] ->
          circuits
          |> Enum.map(fn
            cir when cir in [c1, c2] -> c1 ++ c2
            cir -> cir
          end)
          |> Enum.uniq()
      end
    end)
    |> Enum.map(&length/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  # completes in ~ 1.02 seconds
  def part_2() do
    data =
      File.read!("data/day_8_2.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&List.to_tuple/1)

    initial_circuits = Enum.map(data, &List.wrap/1)

    data
    |> get_shortest_connections()
    |> Enum.reduce_while(initial_circuits, fn {p1, p2, _}, circuits ->
      circuits
      |> Enum.filter(fn cir -> p1 in cir or p2 in cir end)
      |> case do
        [_single] ->
          circuits

        [c1, c2] ->
          circuits
          |> Enum.map(fn
            cir when cir in [c1, c2] -> c1 ++ c2
            cir -> cir
          end)
          |> Enum.uniq()
      end
      |> case do
        [_single] ->
          {x1, _, _} = p1
          {x2, _, _} = p2

          {:halt, x1 * x2}

        new_circuits ->
          {:cont, new_circuits}
      end
    end)
  end

  def get_shortest_connections(data) do
    data
    |> Enum.flat_map(fn point1 ->
      data
      |> Enum.reject(&(&1 == point1))
      |> Enum.map(fn point2 ->
        {point1, point2}
      end)
    end)
    |> Enum.map(fn {p1, p2} -> {p1, p2, calculate_distance(p1, p2)} end)
    |> Enum.uniq_by(fn {p1, p2, _} -> Enum.sort([p1, p2]) end)
    |> Enum.sort_by(fn {_, _, d} -> d end)
  end

  def calculate_distance({x1, y1, z1}, {x2, y2, z2}) do
    Enum.sum([
      Integer.pow(x2 - x1, 2),
      Integer.pow(y2 - y1, 2),
      Integer.pow(z2 - z1, 2)
    ])
    |> :math.sqrt()
  end
end
