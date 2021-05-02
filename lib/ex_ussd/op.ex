defmodule ExUssd.Op do
  alias ExUssd.{Utils, NavGraph, Registry, Route, Ops, Display}

  @allowed_fields [:title, :next, :previous, :should_close, :split, :delimiter_style]

  def new(fields) when is_list(fields),
    do: new(Enum.into(fields, %{data: Keyword.get(fields, :data)}))

  def new(%{name: name, handler: handler, data: data}) do
    menu = %ExUssd{
      name: name,
      handler: handler,
      id: Utils.generate_id(),
      callback: fn api_parameters ->
        menu = struct!(ExUssd, name: name, handler: handler, data: data)
        menu.handler.callback(menu, api_parameters)
      end
    }

    NavGraph.add(menu)
    menu
  end

  def add(%ExUssd{} = menu, %ExUssd{} = child, :multi) do
    {menu_list, _state} = Map.get(menu, :menu_list, {[], true})

    NavGraph.path(menu, Map.merge(child, %{navigate: :multi}))

    menu
    |> Map.put(
      :menu_list,
      {Enum.reverse([child | menu_list]), true}
    )
  end

  def add(%ExUssd{} = menu, %ExUssd{} = child, :single) do
    NavGraph.path(menu, Map.merge(child, %{navigate: :single}))

    menu
    |> Map.put(
      :validation_menu,
      {child, true}
    )
  end

  def set(%ExUssd{} = menu, fields) do
    if MapSet.subset?(MapSet.new(Keyword.keys(fields)), MapSet.new(@allowed_fields)) do
      menu
      |> Map.merge(Enum.into(fields, %{}, fn {k, v} -> {k, {v, true}} end))
    else
      raise RuntimeError,
        message:
          "Expected field allowable fields #{inspect(@allowed_fields)} found #{
            inspect(Keyword.keys(fields))
          }"
    end
  end

  def goto(fields) when is_list(fields),
    do: new(Enum.into(fields, %{}))

  def goto(%{
        api_parameters:
          %{"text" => text, "session_id" => session_id, "service_code" => service_code} =
            api_parameters,
        menu: menu
      }) do
    api_parameters = for {key, val} <- api_parameters, into: %{}, do: {String.to_atom(key), val}

    route = Routes.get_route(%{text: text, service_code: service_code})

    current_menu =
      case Registry.lookup(session_id) do
        {:error, :not_found} ->
          Registry.start(session_id)
          Ops.circle(Enum.reverse(route), menu, api_parameters)

        {:ok, pid} ->
          menu = Registry.get_current(session_id)
          {_, current_menu} = Ops.navigate(route, menu, api_parameters)
          current_menu
      end

    Display.new(
      menu: current_menu,
      route: Registry.get(session_id),
      api_parameters: api_parameters
    )
  end
end
