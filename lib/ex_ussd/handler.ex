defmodule ExUssd.Handler do
  @moduledoc ~S"""
  This module provides callbacks to implement ExUssd handler.
  """

  @doc ~S"""
  ## Examples
      defmodule MyHomeHandler do
        use ExUssd.Handler
        def init(menu, _api_parameters) do
          menu |> ExUssd.set(title: "Enter your pin number")
        end

        def callback(menu, api_parameters) do
          case api_parameters.text == "5555" do
            true ->
              menu
              |> ExUssd.set(title: "success, thank you.")
              |> ExUssd.set(should_close: true)

            _ ->
              menu |> ExUssd.set(error: "Wrong pin number\n")
          end
        end
      end
  """

  @type menu() :: ExUssd.t()
  @type api_parameters() :: map()

  @callback init(
              menu :: menu(),
              api_parameters :: api_parameters()
            ) ::
              menu :: menu()

  @callback callback(
              menu :: menu(),
              api_parameters :: api_parameters()
            ) ::
              menu :: menu()

  defmacro __using__([]) do
    quote do
      @behaviour ExUssd.Handler

      @impl ExUssd.Handler
      def callback(menu, api_parameters), do: ExUssd.Handler.get(__MODULE__, menu, api_parameters)
      defoverridable ExUssd.Handler
    end
  end

  def callback(_menu, _api_parameters) do
    {:error, "Not implemented"}
  end
end
