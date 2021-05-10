# ExUssd

Example New USSD API

### Simple USSD menu
Implement ExUssd `init/2` callback.
Use `ExUssd.set/2` to set USSD value

@allowed_fields [
    :error,
    :title,
    :next,
    :previous,
    :should_close,
    :split,
    :delimiter_style,
    :continue
  ]

```elixir
  defmodule MyHomeHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "Welcome")
    end
  end

  menu = ExUssd.new(name: "Home", handler: MyHomeHandler)

  api_parameters = %{"service_code" => "*544#", "session_id" => "session_01", "text" => ""}

  ExUssd.goto(menu: menu, api_parameters: api_parameters)

  {:ok, %{menu_string: "Welcome", should_close: false}}
```

### End USSD Session

Manually close USSD session, Use `ExUssd.end_session/1` it takes the `session_id` as params

```elixir
  defmodule MyHomeHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "Welcome")
      |> ExUssd.set(should_close: true)
    end
  end

  menu = ExUssd.new(name: "Home", handler: MyHomeHandler)

  api_parameters = %{"service_code" => "*544#", "session_id" => "session_01", "text" => ""}

  ExUssd.goto(menu: menu, api_parameters: api_parameters)
    |> case do
    {:ok, %{menu_string: menu_string, should_close: false}} ->
      "CON " <> menu_string

    {:ok, %{menu_string: menu_string, should_close: true}} ->
      # End Session
      ExUssd.end_session(session_id: "session_01")

      "END " <> menu_string
    end
```

### USSD Simple List
Use `ExUssd.add/2` to add to USSD menu list.
The USSD menu list is `[]` by default.

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
    end
  end
  
  defmodule MyHomeHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "Welcome")
      |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
      |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
      |> ExUssd.add(ExUssd.new(name: "Product C", handler: ProductCHandler))
    end
  end

  menu = ExUssd.new(name: "Home", handler: MyHomeHandler)
```

### USSD Nested List
Use `ExUssd.add/2` to add to USSD menu list on Individual USSD menu.

```elixir
  
  defmodule ProductCHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "selected product c")
    end
  end
  
  defmodule ProductBHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "selected product b")
      |> ExUssd.add(ExUssd.new(name: "Product C", handler: ProductCHandler))
    end
  end

  defmodule ProductAHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "selected product a")
      |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
    end
  end

  defmodule MyHomeHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "Welcome")
      |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))    
    end
  end

  menu = ExUssd.new(name: "Home", handler: MyHomeHandler)
```

### USSD navigation response
Implement `navigation_response/1` function on your USSD handler module.
`navigation_response/1` callback returns navigation status.

#### Scenario  
User passes in invalid
 - payload {:error, api_parameters}

User passes in valid input, name navigated to next menu
 - payload {:ok, api_parameters}

```elixir
  # ...
  defmodule MyHomeHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "Welcome")
      |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
      |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
      |> ExUssd.add(ExUssd.new(name: "Product C", handler: ProductCHandler))
    end

    def navigation_response(payload) do
      IO.inspect payload
    end
  end
  
  menu = ExUssd.new(name: "Home", handler: MyHomeHandler)
```

### Using USSD `callback/2`
Implement ExUssd `callback/2` in the event you need to validate the Users input 

#### Simple validation menu

```elixir
  # ...
  defmodule MyHomeHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "Welcome")
      |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
      |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
      |> ExUssd.add(ExUssd.new(name: "Product C", handler: ProductCHandler))
    end

    def callback(menu, api_parameters) do
      case api_parameters.text == "5555" do
        true ->
          menu
          |> ExUssd.set(title: "You have Entered the Secret Number, 5555")
          |> ExUssd.set(should_close: true)
          |> ExUssd.set(continue: true)

        _ ->
          menu 
          |> ExUssd.set(continue: false)
      end
    end
  end

  menu = ExUssd.new(name: "Home", handler: MyHomeHandler)

  api_parameters = %{"service_code" => "*544#", "session_id" => "session_01", "text" => "5555"}

  ExUssd.goto(menu: menu, api_parameters: api_parameters)

  {:ok, %{menu_string: "You have Entered the Secret Number, 5555", should_close: false}}
```

#### Nested validation menu

```elixir
  # ...
  defmodule MyHomeHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu 
      |> ExUssd.set(title: "Welcome")
      |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
      |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
      |> ExUssd.add(ExUssd.new(name: "Product C", handler: ProductCHandler))
    end

    def callback(menu, api_parameters) do
      case api_parameters.text == "5555" do
        true ->
          menu
          |> ExUssd.set(title: "You have Entered the Secret Number, 5555")
          |> ExUssd.set(should_close: true)
          |> ExUssd.set(continue: true)

        _ ->
          menu 
          |> ExUssd.set(continue: false)
      end
    end
  end

  defmodule PinHandler do
    use ExUssd.Handler
    def init(menu, _api_parameters) do
      menu |> ExUssd.set(title: "Enter your pin number")
    end

    def callback(menu, api_parameters) do
      case api_parameters.text == "4321" do
        true ->
          menu
          |> ExUssd.navigate(handler: MyHomeHandler)
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

  menu = ExUssd.new(name: "Check PIN", handler: PinHandler)
  # ...
```



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_ussd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_ussd, git: "https://github.com/lenileiro/ex_ussd.git", branch: "main"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_ussd](https://hexdocs.pm/ex_ussd).

