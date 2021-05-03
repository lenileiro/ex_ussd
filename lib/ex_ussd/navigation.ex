defmodule ExUssd.Navigation do
  alias ExUssd.Registry
  alias ExUssd.Utils

  @default_value 436_739_010_658_356_127_157_159_114_145
  def navigate(
        %ExUssd{} = menu,
        api_parameters,
        route
      ) do
    {menus, _} = menu.menu_list
    {validation_menu, _} = menu.validation_menu
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

        {_, menu} = Registry.get_current(session_id)

        {_, current_menu} =
          case depth do
            1 -> {:ok, menu.parent.()}
            _ -> {:ok, menu}
          end

        case current_menu.parent do
          nil ->
            {:ok,
             Map.merge(current_menu, %{
               parent: fn -> %{current_menu | error: {nil, true}} end
             })}

          _ ->
            {:ok, current_menu}
        end

      605_356_150_351_840_375_921_999_017_933 ->
        Registry.next(session_id)
        Registry.get_current(session_id)

      705_897_792_423_629_962_208_442_626_284 ->
        Registry.set(session_id, %{depth: 1, value: "555"})
        Registry.get_home(session_id)

      depth ->
        next_menu(depth, menus, validation_menu, api_parameters, menu, route)
    end
  end

  defp next_menu(555, _menus, nil, %{session_id: session_id} = api_parameters, menu, route) do
    Registry.set(session_id, route)
    parent_menu = Utils.invoke_callback(menu, api_parameters)

    {:ok,
     Map.merge(parent_menu, %{
       parent: fn -> %{parent_menu | error: {nil, true}} end
     })}
  end

  defp next_menu(_depth, [], validation_menu, api_parameters, menu, route) do
    get_validation_menu(validation_menu, api_parameters, menu, route)
  end

  defp next_menu(depth, {_, menus}, nil, %{session_id: session_id} = api_parameters, menu, route)
       when is_integer(depth) do
    case Enum.at(menus, depth - 1) do
      nil ->
        parent = if length(Registry.get(session_id)) == 1, do: menu, else: menu.parent.()

        {:error,
         Map.merge(menu, %{
           error: {Map.get(menu, :default_error), true},
           parent: fn -> %{parent | error: {nil, true}} end
         })}

      child_menu ->
        Registry.add(session_id, route)

        {:ok,
         Map.merge(Utils.invoke_callback(child_menu, api_parameters), %{
           parent: fn -> %{menu | error: {nil, true}} end
         })}
    end
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

        {:ok,
         Map.merge(Utils.invoke_callback(child_menu, api_parameters), %{
           parent: fn -> %{menu | error: {nil, true}} end
         })}
    end
  end

  defp get_validation_menu(
         validation_menu,
         %{session_id: session_id} = api_parameters,
         menu,
         route
       )
       when not is_nil(validation_menu) do
    current_menu =
      Utils.invoke_callback(validation_menu, Map.put(api_parameters, :text, route.value))

    %{error: {error, _}} = current_menu

    case error do
      nil ->
        Registry.add(session_id, route)

        {:ok,
         Map.merge(current_menu, %{
           parent: fn -> %{menu | error: {nil, true}} end
         })}

      _ ->
        go_back_menu =
          case menu.parent do
            nil -> menu
            _ -> menu.parent.()
          end

        {:error,
         Map.merge(menu, %{
           error: {error, true},
           parent: fn -> %{go_back_menu | error: {nil, true}} end
         })}
    end
  end

  defp get_validation_menu(validation_menu, _api_parameters, menu, _route)
       when is_nil(validation_menu) do
    {:error, Map.merge(menu, %{error: {Map.get(menu, :default_error), true}})}
  end

  defp to_int({value, ""}, menu, input_value) do
    %{
      next: {%{input_match: next}, false},
      previous: {%{input_match: previous}, false}
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
