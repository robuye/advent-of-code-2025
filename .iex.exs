IEx.configure(inspect: [charlists: :as_lists])

defmodule H do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  def print_grid(map) do
    # %{{x y} => chr}

    {{max_x, _}, _} = Enum.max_by(map, fn {{x, _y}, _} -> x end)
    {{_, max_y}, _} = Enum.max_by(map, fn {{_x, y}, _} -> y end)

    IO.puts("")

    Enum.map(0..max_y + 1, fn y ->
      Enum.reduce(0..max_x + 1, "", fn x, acc ->
        chr = Map.get(map, {x, y}, ".")

        acc <> chr
      end)
    end)
    |> Enum.each(&IO.puts/1)

    IO.puts("")

    :ok
  end
end
