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

defmodule MyHomeHandler do
  use ExUssd.Handler
  def init(menu, _api_parameters) do
    menu |> ExUssd.set(title: "Welcome")
  end

  def callback(menu, api_parameters) do
    case api_parameters.text == "5555" do
      true ->
        menu
        |> ExUssd.set(title: "success, found secret key.")
        |> ExUssd.set(should_close: true)

      _ ->
        menu |> ExUssd.set(error: "")
    end
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

      _ ->
        menu |> ExUssd.set(error: "Wrong pin number\n")
    end
  end
end