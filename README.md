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

  ExUssd.new(name: "Home", handler: MyHomeHandler)
    |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
    |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
    |> ExUssd.add(ExUssd.new(name: "Product C", handler: ProductCHandler))
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

