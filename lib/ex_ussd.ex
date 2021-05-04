defmodule ExUssd do
  @moduledoc """
  Documentation for `ExUssd`.

  Example

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

  ExUssd.new(name: "Home", handler: MyHomeHandler)
    |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
    |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
    |> ExUssd.add(ExUssd.new(name: "Change PIN", handler: PinHandler))
   
  """

  alias __MODULE__

  @type t :: %__MODULE__{
          name: String.t(),
          handler: fun(),
          title: {String.t(), boolean()},
          menu_list: {[%__MODULE__{}], boolean()},
          error: {String.t(), boolean()},
          show_navigation: {boolean(), boolean()},
          next: {map(), boolean()},
          previous: {map(), boolean()},
          split: {integer(), boolean()},
          should_close: {boolean(), boolean()},
          delimiter_style: {String.t(), boolean()},
          parent: %__MODULE__{},
          validation_menu: {%__MODULE__{}, boolean()},
          data: map(),
          id: String.t(),
          default_error: String.t(),
          init: fun()
        }

  # @derive {Inspect, only: [:name, :menu_list, :title]}
  defstruct name: nil,
            handler: nil,
            title: {nil, false},
            menu_list: {[], false},
            error: {nil, false},
            handle: {false, false},
            success: {false, false},
            show_navigation: {true, false},
            next: {%{name: "MORE", input_match: "98", display_style: ":"}, false},
            previous: {%{name: "BACK", input_match: "0", display_style: ":"}, false},
            split: {7, false},
            should_close: {false, false},
            delimiter_style: {":", false},
            parent: nil,
            validation_menu: {nil, false},
            validate: {nil, false},
            data: nil,
            id: nil,
            init: nil,
            default_error: "Invalid Choice\n"

  defdelegate new(opts), to: ExUssd.Op
  defdelegate add(menu, opts), to: ExUssd.Op
  defdelegate set(menu, opts), to: ExUssd.Op
  defdelegate goto(opts), to: ExUssd.Op
end
