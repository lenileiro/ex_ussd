defmodule ProductAHandler do
    @behaviour ExUssd.Handler
    def callback(menu, _api_parameters) do
      menu |> ExUssd.set(title: "selected product a")
    end
  end

  defmodule ProductBHandler do
    @behaviour ExUssd.Handler
    def callback(menu, _api_parameters) do
      menu |> ExUssd.set(title: "selected product b")
    end
  end

  defmodule ProductCHandler do
    @behaviour ExUssd.Handler
    def callback(menu, _api_parameters) do
      menu |> ExUssd.set(title: "selected product c")
    end
  end

  defmodule MyHomeHandler do
    @behaviour ExUssd.Handler
    def callback(menu, _api_parameters) do
      menu |> ExUssd.set(title: "Welcome")
    end
  end

  defmodule PinHandler do
    @behaviour ExUssd.Handler
    def callback(menu, _api_parameters) do
      menu |> ExUssd.set(title: "Enter your pin number")
    end
  end

   defmodule PinValidateHandler do
    @behaviour ExUssd.Handler
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