defmodule ExUssd do
  @moduledoc """
  Documentation for `ExUssd`.

  Example

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

  defmodule ProductPriceHandler do
    @behaviour ExUssd.Handler
    def callback(menu, _api_parameters) do
      menu |> ExUssd.set(title: "Price")
    end
  end


  product = ExUssd.new(name: "Product C", handler: ProductCHandler)
   |> ExUssd.add(ExUssd.new(name: "Price", handler: ProductPriceHandler), :single)

  ExUssd.new(name: "Home", handler: MyHomeHandler)
    |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler), :multi)
    |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler), :multi)
    |> ExUssd.add(product, :multi)
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
          default_error: String.t()
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
            data: nil,
            id: nil,
            default_error: "Invalid Choice\n"

  defdelegate new(opts), to: ExUssd.Op
  defdelegate add(menu, opts, type), to: ExUssd.Op
  defdelegate set(menu, opts), to: ExUssd.Op
end
