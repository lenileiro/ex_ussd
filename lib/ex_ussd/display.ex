defmodule ExUssd.Display do
  def new(fields) when is_list(fields),
    do: new(Enum.into(fields, %{}))

  def new(%{
        menu: menu,
        routes: routes,
        api_parameters: api_parameters
      }) do
    builder(menu, routes, api_parameters)
  end

  def new(%{menu: menu, routes: routes}) do
    builder(menu, routes, Map.new())
  end

  defp builder(
         %ExUssd{
           delimiter: {delimiter_style, _},
           error: {error, _},
           menu_list: {menu_list, _},
           next: {%{delimiter: next_display_style, next: next, name: next_name}, _},
           previous:
             {%{
                delimiter: previous_display_style,
                previous: previous,
                name: previous_name
              }, _},
           should_close: {should_close, _},
           split: {split, _},
           success: {false, _},
           title: {title, _},
           show_navigation: {show_navigation, _}
         } = menu,
         routes,
         _api_parameters
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
        case Enum.at(Enum.reverse(menu_list), elem(x, 0)) do
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
      cond do
        menus == [] and show_navigation == true ->
          "#{error}#{title}" <> previous_navigation <> next_navigation

        menus == [] and show_navigation == false ->
          "#{error}#{title}"

        menus != [] ->
          "#{error}#{title}\n" <> Enum.join(menus, "\n") <> previous_navigation <> next_navigation
      end

    {should_close, _} = menu.should_close
    {:ok, %{menu_string: menu_string, should_close: should_close}}
  end
end
