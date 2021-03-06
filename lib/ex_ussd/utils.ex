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

  def truncate(text, options \\ []) do
    len = options[:length] || 30
    omi = options[:omission] || "..."

    cond do
      !String.valid?(text) ->
        text

      String.length(text) < len ->
        text

      true ->
        len_with_omi = len - String.length(omi)

        stop =
          if options[:separator] do
            rindex(text, options[:separator], len_with_omi) || len_with_omi
          else
            len_with_omi
          end

        "#{String.slice(text, 0, stop)}#{omi}"
    end
  end

  defp rindex(text, str, _offset) do
    revesed = text |> String.reverse()
    matchword = String.reverse(str)

    case :binary.match(revesed, matchword) do
      {at, strlen} ->
        String.length(text) - at - strlen

      :nomatch ->
        nil
    end
  end

  def invoke_init(menu, api_parameters) do
    apply(menu.handler, :init, [menu, api_parameters])
  end

  def invoke_callback(%ExUssd{} = menu, api_parameters) do
    try do
      apply(menu.handler, :callback, [menu, api_parameters])
    rescue
      _e in UndefinedFunctionError -> nil
    end
  end

  def navigation_response(menu, payload) do
    apply(menu.handler, :navigation_response, [payload])
  end
end
