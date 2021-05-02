defmodule ExUssd.Ops do
  alias ExUssd.{Registry, Utils, Navigation, NavGraph}

  def circle(
        [%{depth: 1, value: "555"}] = route,
        %ExUssd{} = menu,
        %{session_id: session_id} = api_parameters
      ) do
    home = Utils.invoke_callback(menu, api_parameters)
    home = Map.merge(home, %{parent: fn -> %{home | error: nil} end})
    Registry.set_home(session_id, home)
    Registry.set_current(session_id, home)
    Registry.add(session_id, route)
    home
  end

  def circle([%{depth: 1, value: "555"} | tail], %ExUssd{} = menu, api_parameters) do
    home = circle([%{depth: 1, value: "555"}], menu, api_parameters)
    circle(tail, home, api_parameters)
  end

  def circle([head | tail], %ExUssd{} = menu, api_parameters) do
    navigate(head, menu, api_parameters)
    |> case do
      {:ok, current_menu} -> circle(tail, current_menu, api_parameters)
      {:error, current_menu} -> current_menu
    end
  end

  def circle([], %ExUssd{} = menu, _api_parameters) do
    menu
  end

  def navigate(%{} = route, %ExUssd{} = menu, %{session_id: session_id} = api_parameters) do
    children = Graph.out_neighbors(NavGraph.all(), menu)

    Navigation.navigate(menu, children, api_parameters, route)
    |> (fn {_, current_menu} = response ->
          Registry.set_current(session_id, current_menu)
          response
        end).()
  end
end
