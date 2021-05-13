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
          delimiter: {String.t(), boolean()},
          parent: %__MODULE__{},
          validation_menu: {%__MODULE__{}, boolean()},
          data: map(),
          id: String.t(),
          default_error: String.t(),
          continue: {boolean(), boolean()},
          show_navigation: {boolean(), boolean()}
        }

  # @derive {Inspect, only: [:name, :menu_list, :title, :validation_menu]}
  defstruct name: nil,
            handler: nil,
            title: {nil, false},
            menu_list: {[], false},
            error: {nil, false},
            handle: {false, false},
            success: {false, false},
            show_navigation: {true, false},
            next: {%{name: "MORE", next: "98", delimiter: ":"}, false},
            previous: {%{name: "BACK", previous: "0", delimiter: ":"}, false},
            split: {7, false},
            should_close: {false, false},
            delimiter: {":", false},
            parent: nil,
            validation_menu: {nil, false},
            data: nil,
            id: nil,
            init: nil,
            continue: {nil, false},
            orientation: :horizontal,
            default_error: "Invalid Choice\n"

  defdelegate new(opts), to: ExUssd.Op
  defdelegate add(menu, opts), to: ExUssd.Op
  defdelegate navigate(menu, opts), to: ExUssd.Op
  defdelegate set(menu, opts), to: ExUssd.Op
  defdelegate goto(opts), to: ExUssd.Op
  defdelegate end_session(opts), to: ExUssd.Op
  defdelegate dynamic(menu, opts), to: ExUssd.Op

  # use Phoenix.Router
  # use Agent

  # def start_link(opts) do
  #   name =
  #     opts[:name] ||
  #       raise ArgumentError, "the :name option is required by #{inspect(__MODULE__)}"

  #   metrics =
  #     opts[:metrics] ||
  #       raise ArgumentError, "the :metrics option is required by #{inspect(__MODULE__)}"

  #   Agent.start_link(fn -> %{metrics: metrics} end, name: name)
  # end

  # def init(opts) do
  #   _name =
  #     opts[:name] ||
  #       raise ArgumentError, "the :name option is a required by #{inspect(__MODULE__)}.init/1"
  #   opts
  # end
  # def call(conn, opts) do
  #   conn
  #   |> put_layout({Phoenix.LiveDashboard.LayoutView, :dash})
  #   |> put_private(:phoenix_live_dashboard,
  #     router: Phoenix.Controller.router_module(conn),
  #     session: %{"name" => opts[:name]}
  #   )
  #   |> super(opts)
  # end

  # get("/", Phoenix.ExUssd.Plug, LiveDashboard.TelemetryLive)
end
