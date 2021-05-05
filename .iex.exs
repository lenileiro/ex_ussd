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