defmodule ExUssd.Op do
  alias ExUssd.{Utils, Registry, Ops, Display, Route}
  require ExUssd.Utils

  @allowed_fields [
    :error,
    :title,
    :next,
    :previous,
    :should_close,
    :split,
    :delimiter_style,
    :continue,
    :default_error,
    :show_navigation
  ]

  def new(fields) when is_list(fields),
    do: new(Enum.into(fields, %{data: Keyword.get(fields, :data)}))

  def new(%{name: name, handler: handler, data: data}) do
    %ExUssd{
      name: name,
      handler: handler,
      id: Utils.generate_id(),
      data: data,
      validation_menu: {%ExUssd{name: "", handler: handler}, false}
    }
  end

  def add(%ExUssd{} = menu, %ExUssd{} = child) do
    {menu_list, _state} = Map.get(menu, :menu_list, {[], true})

    menu
    |> Map.put(
      :menu_list,
      {[child | menu_list], true}
    )
  end

  def navigate(%ExUssd{} = menu, fields) when is_list(fields),
    do: navigate(menu, Enum.into(fields, %{data: Keyword.get(fields, :data)}))

  def navigate(%ExUssd{} = menu, %{handler: handler, data: data}) do
    menu
    |> Map.put(
      :validation_menu,
      {%ExUssd{name: "", handler: handler, data: data}, true}
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

  def end_session(session_id: session_id) do
    Registry.stop(session_id)
  end

  def goto(fields) when is_list(fields),
    do: goto(Enum.into(fields, %{}))

  def goto(%{
        api_parameters:
          %{"text" => text, "session_id" => session_id, "service_code" => service_code} =
            api_parameters,
        menu: menu
      }) do
    api_parameters =
      for {key, val} <- api_parameters, into: %{}, do: {String.to_existing_atom(key), val}

    route = Route.get_route(%{text: text, service_code: service_code, session_id: session_id})

    {_, current_menu} =
      case Registry.lookup(session_id) do
        {:error, :not_found} ->
          Registry.start(session_id)
          Registry.add(session_id, route)
          current_menu = Ops.circle(Enum.reverse(route), menu, api_parameters)
          Registry.set_current(session_id, current_menu)
          current_menu

        {:ok, _pid} ->
          {_, current_menu} = Registry.get_current(session_id)
          current_menu = Ops.circle(route, current_menu, api_parameters, menu)
          Registry.set_current(session_id, current_menu)
          current_menu
      end

    Display.new(
      menu: current_menu,
      routes: Registry.get(session_id),
      api_parameters: api_parameters
    )
  end

  def goto(%{
        api_parameters:
          %{"session_id" => _session_id, "service_code" => _service_code} = api_parameters,
        menu: _menu
      }) do
    raise RuntimeError,
      message: "'text' not found in api_parameters #{inspect(api_parameters)}"
  end

  def goto(%{
        api_parameters: %{"text" => _text, "service_code" => _service_code} = api_parameters,
        menu: _menu
      }) do
    raise RuntimeError,
      message: "'session_id' not found in api_parameters #{inspect(api_parameters)}"
  end

  def goto(%{
        api_parameters: %{"text" => _text, "session_id" => _session_id} = api_parameters,
        menu: _menu
      }) do
    raise RuntimeError,
      message: "'service_code' not found in api_parameters #{inspect(api_parameters)}"
  end

  def goto(%{
        api_parameters: api_parameters,
        menu: _menu
      }) do
    raise RuntimeError,
      message:
        "'text', 'service_code', 'session_id',  not found in api_parameters #{
          inspect(api_parameters)
        }"
  end
end
