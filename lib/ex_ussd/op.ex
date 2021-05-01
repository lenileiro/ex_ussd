defmodule ExUssd.Op do
  alias ExUssd

  @allowed_fields [:title, :next, :previous, :should_close, :split, :delimiter_style]

  def new(fields) when is_list(fields),
    do: new(Enum.into(fields, %{data: Keyword.get(fields, :data), execute: true}))

  def new(%{name: name, handler: handler, data: data, execute: true}) do
    %ExUssd{
      name: name,
      handler: handler,
      callback: fn api_parameters ->
        menu = struct!(ExUssd, name: name, handler: handler, data: data)
        menu.handler.callback(menu, api_parameters)
      end
    }
  end

  def new(%{name: name, handler: handler, data: data}) do
    %ExUssd{
      name: name,
      handler: handler,
      data: data
    }
  end

  def add(%ExUssd{} = menu, opts) do
    {menu_list, _state} = Map.get(menu, :menu_list, {[], true})

    menu
    |> Map.put(
      :menu_list,
      {Enum.reverse([new(opts) | menu_list]), true}
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
end
