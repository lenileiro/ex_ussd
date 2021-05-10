defmodule ExUssd do
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
          init: fun(),
          continue: {boolean(), boolean()}
        }

  @derive {Inspect, only: [:name, :menu_list, :title, :validation_menu]}
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
            continue: {nil, false},
            default_error: "Invalid Choice\n"

  defdelegate new(opts), to: ExUssd.Op
  defdelegate add(menu, opts), to: ExUssd.Op
  defdelegate navigate(menu, opts), to: ExUssd.Op
  defdelegate set(menu, opts), to: ExUssd.Op
  defdelegate goto(opts), to: ExUssd.Op
  defdelegate end_session(opts), to: ExUssd.Op
end
