defmodule ExUssd.Utils do
  def generate_id() do
    min = String.to_integer("1000000000000", 36)
    max = String.to_integer("ZZZZZZZZZZZZZZ", 36)

    max
    |> Kernel.-(min)
    |> :rand.uniform()
    |> Kernel.+(min)
    |> Integer.to_string(36)
  end

  def invoke_init(menu, api_parameters) do
    menu.init.(menu, api_parameters)
  end

  def invoke_callback(%ExUssd{} = menu, api_parameters) do
    case menu.handler.callback(menu, api_parameters) do
      {:error, "Not implemented"} -> nil
      %ExUssd{} = current_menu -> current_menu
    end
  end
end
