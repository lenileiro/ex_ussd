defmodule ExUssd.Display do
  def new(fields) when is_list(fields),
    do: new(Enum.into(fields, %{data: Keyword.get(fields, :data)}))

  def new(%{menu: menu, route: route, api_parameters: %{session_id: session_id} = api_parameters}) do
    builder(menu, routes, api_parameters, session_id)
  end

  def new(%{menu: menu, route: route}) do
    builder(menu, routes, Map.new(), "")
  end

  defp builder(
         %ExUssd{
           title: title,
           error: error,
           split: split,
           menu_list: menu_list,
           should_close: should_close,
           delimiter_style: delimiter_style,
           next: %{name: next_name, input_match: next, display_style: next_display_style},
           previous: %{
             name: previous_name,
             input_match: previous,
             display_style: previous_display_style
           }
         } = menu,
         routes,
         api_parameters,
         session_id
       ) do
    %{depth: page} = List.first(routes)

    # {0, 6}
    {min, max} = {split * (page - 1), page * split - 1}

    # [0, 1, 2, 3, 4, 5, 6]
    selection = Enum.into(min..max, [])

    # [{0, 0}, {1, 1}, {2, 2}, {3, 3}, {4, 4}, {5, 5}, {6, 6}]
    positions = selection |> Enum.with_index()

    menus =
      Enum.map(positions, fn x ->
        case Enum.at(menu_list, elem(x, 0)) do
          nil ->
            nil

          current_menu ->
            %{name: name} = current_menu
            "#{elem(x, 1) + 1 + min}#{delimiter_style}#{name}"
        end
      end)
      |> Enum.filter(fn value -> value != nil end)

    previous_navigation =
      cond do
        length(routes) == 1 and page == 1 ->
          ""

        length(routes) == 1 and page > 1 ->
          "\n" <> "#{previous}#{previous_display_style}#{previous_name}"

        length(routes) > 1 and should_close == false ->
          "\n" <> "#{previous}#{previous_display_style}#{previous_name}"

        length(routes) > 1 and should_close == true ->
          ""
      end

    next_navigation =
      cond do
        Enum.at(menu_list, max + 1) == nil -> ""
        length(routes) == 1 -> "\n#{next}#{next_display_style}#{next_name}"
        length(routes) > 1 -> " " <> "#{next}#{next_display_style}#{next_name}"
      end

    menu_string =
      case menus do
        [] ->
          "#{error}#{title}" <> previous_navigation <> next_navigation

        _ ->
          "#{error}#{title}\n" <> Enum.join(menus, "\n") <> previous_navigation <> next_navigation
      end

    {:ok, %{menu_string: menu_string, menu: menu}}
  end
end
