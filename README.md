# ExUssd

Example New USSD API

```elixir
   defmodule ProductAHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu |> ExUssd.set(title: "selected product a")
    end
  end

  defmodule ProductBHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu |> ExUssd.set(title: "selected product b")
    end
  end

  defmodule ProductCHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "selected product c")
      |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
    end
  end

  defmodule MyHomeHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu |> ExUssd.set(title: "Welcome")
    end

    def navigation_response(payload) do
      IO.inspect payload
    end
  end

   defmodule PinHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu |> ExUssd.set(title: "Enter your pin number")
    end

    def callback(menu, api_parameters) do
      case api_parameters.text == "5555" do
        true ->
          menu
          |> ExUssd.set(title: "success, Thank you.")
          |> ExUssd.set(should_close: true)
          |> ExUssd.set(continue: true)

        _ ->
          menu 
          |> ExUssd.set(error: "Wrong pin number\n")
          |> ExUssd.set(continue: false)
      end
    end
    
    def navigation_response(payload) do
      IO.inspect payload
    end
  end

  ExUssd.new(name: "Home", handler: MyHomeHandler)
    |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
    |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
    |> ExUssd.add(ExUssd.new(name: "Product C", handler: ProductCHandler))
    |> ExUssd.add(ExUssd.new(name: "Change PIN", handler: PinHandler))

  ExUssd.goto(menu: menu, api_parameters: 
  %{"service_code" => "*544#", "session_id" => "session_01", "text" => "*544#"})
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

