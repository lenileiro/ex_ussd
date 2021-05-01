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

  ExUssd.new(name: "Home", handler: MyHomeHandler)
    |> ExUssd.add(ExUssd.new(name: "Product A", handler: ProductAHandler))
    |> ExUssd.add(ExUssd.new(name: "Product B", handler: ProductBHandler))
    |> ExUssd.add(ExUssd.new(name: "Product C", handler: ProductCHandler))
  """

  alias __MODULE__

  @typep callback :: (ExUssd.t(), map() -> ExUssd.t())

  @type t :: %__MODULE__{
          name: String.t(),
          callback: callback,
          handler: fun(),
          title: {String.t(), boolean()},
          menu_list: {[%__MODULE__{}], boolean()},
          error: {String.t(), boolean()},
          show_navigation: {boolean(), boolean()},
          next: {String.t(), boolean()},
          previous: {String.t(), boolean()},
          split: {integer(), boolean()},
          should_close: {boolean(), boolean()},
          delimiter_style: {String.t(), boolean()},
          parent: {%__MODULE__{}, boolean()},
          validation_menu: {%__MODULE__{}, boolean()},
          data: map()
        }

  # @derive {Inspect, only: [:name, :menu_list, :title]}
  defstruct name: nil,
            callback: nil,
            handler: nil,
            title: {nil, false},
            menu_list: {[], false},
            error: {nil, false},
            handle: {false, false},
            success: {false, false},
            show_navigation: {true, false},
            next: {"98", false},
            previous: {"0", false},
            split: {7, false},
            should_close: {false, false},
            delimiter_style: {":", false},
            parent: {nil, false},
            validation_menu: {nil, false},
            data: nil

  defdelegate new(opts), to: ExUssd.Op
  defdelegate add(menu, opts), to: ExUssd.Op
  defdelegate set(menu, opts), to: ExUssd.Op
end
