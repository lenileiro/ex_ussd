defmodule ExUssd.Handler do
  @moduledoc ~S"""
  This module provides callbacks to implement ExUssd handler.
  """

  @doc ~S"""
  Callback for event handling.
  This callback takes an menu struct, and api_parameters data as the input.
  ## Examples
      defmodule MyHomeHandler do
        @behaviour ExUssd.Handler
        def callback(menu, api_parameters) do
          menu |> Map.put(:title, "Welcome")
        end
      end
  """
  @type menu() :: ExUssd.t()
  @type api_parameters() :: map()

  @callback callback(
              menu :: menu(),
              api_parameters :: api_parameters()
            ) ::
              menu :: menu()
end
