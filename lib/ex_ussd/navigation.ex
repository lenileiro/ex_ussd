defmodule ExUssd.Navigation do
  alias ExUssd.Registry
  alias ExUssd.Utils

  @default_value 436_739_010_658_356_127_157_159_114_145
  def navigate(
        %ExUssd{} = menu,
        [] = children,
        api_parameters,
        route
      ) do
    menus = Enum.filter(children, fn menu -> match?(%{navigate: :multi}, menu) end)
    validation_menu = Enum.filter(children, fn menu -> match?(%{navigate: :single}, menu) end)
    execute_navigation(menu, menus, validation_menu, api_parameters, route)
  end

  defp execute_navigation(
         menu,
         menus,
         validation_menu,
         %{session_id: session_id} = api_parameters,
         route
       ) do
    depth = to_int(Integer.parse(route[:value]), menu, route[:value])

    case depth do
      128_977_754_852_657_127_041_634_246_588 ->
        %{depth: depth} = Registry.previous(session_id) |> List.first()

        case depth do
          1 -> menu.parent.()
          _ -> menu
        end

      605_356_150_351_840_375_921_999_017_933 ->
        Registry.next(session_id)
        menu

      705_897_792_423_629_962_208_442_626_284 ->
        Registry.set(session_id, %{depth: 1, value: "555"})
        Registry.get_home(session_id)

      depth ->
        next_menu(depth, menus, validation_menu, api_parameters, menu, route)
    end
  end

  defp next_menu(depth, menus, nil, %{session_id: session_id} = api_parameters, menu, route)
       when is_integer(depth) do
    case Enum.at(menus, depth - 1) do
      nil ->
        {:error, Map.put(menu, :error, Map.get(menu, :default_error))}

      child_menu ->
        Registry.add(session_id, route)
        {:ok, Utils.invoke_callback(child_menu, api_parameters)}
    end
  end

  defp next_menu(_depth, [], validation_menu, api_parameters, menu, route) do
    get_validation_menu(validation_menu, api_parameters, menu, route)
  end

  defp next_menu(
         depth,
         menus,
         validation_menu,
         %{session_id: session_id} = api_parameters,
         menu,
         route
       )
       when is_integer(depth) do
    case Enum.at(menus, depth - 1) do
      nil ->
        get_validation_menu(validation_menu, api_parameters, menu, route)

      child_menu ->
        Registry.add(session_id, route)
        {:ok, Utils.invoke_callback(child_menu, api_parameters)}
    end
  end

  defp get_validation_menu(
         validation_menu,
         %{session_id: session_id} = api_parameters,
         menu,
         route
       ) do
    current_menu =
      Utils.invoke_callback(validation_menu, Map.put(api_parameters, :text, route.value))

    %{error: error} = current_menu

    case error do
      nil ->
        Registry.add(session_id, route)
        {:ok, current_menu}

      _ ->
        go_back_menu =
          case menu.parent do
            nil -> menu
            _ -> menu.parent.()
          end

        {:error, Map.merge(menu, %{error: error, parent: fn -> %{go_back_menu | error: nil} end})}
    end
  end

  defp to_int({value, ""}, menu, input_value) do
    %{
      next: %{input_match: next},
      previous: %{input_match: previous}
    } = menu

    case input_value do
      v when v == next ->
        605_356_150_351_840_375_921_999_017_933

      v when v == previous ->
        128_977_754_852_657_127_041_634_246_588

      _ ->
        value
    end
  end

  defp to_int(:error, _menu, _input_value), do: @default_value

  defp to_int({_value, _}, _menu, _input_value), do: @default_value
end
