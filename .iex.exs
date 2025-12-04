IEx.configure(inspect: [charlists: :as_lists])

defmodule H do
  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end
