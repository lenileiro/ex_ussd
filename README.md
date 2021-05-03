# ExUssd

Example New USSD API

```elixir
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

  ExUssd.new(name: "Home", handler: MyHomeHandler, validate: PinValidateHandler)
    |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
    |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
    |> ExUssd.add(ExUssd.new(name: "Change PIN", handler: PinHandler, validate: PinValidateHandler))
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_ussd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_ussd, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_ussd](https://hexdocs.pm/ex_ussd).

