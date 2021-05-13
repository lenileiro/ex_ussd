defmodule Phoenix.ExUssd.Router do
  @moduledoc """
    defmodule MyAppWeb.Router do
      use Phoenix.Router
      import ExUssd.Router

      scope "/", MyAppWeb do
        pipe_through [:browser]
        ussd_simulate "/dashboard",
          contacts: []
      end
    end
  """
  defmacro ussd_simulate(path, opts \\ []) do
    quote bind_quoted: binding() do
      scope path, alias: false, as: false do
        import Phoenix.LiveView.Router, only: [live: 4]
        opts = Phoenix.ExUssd.Router.__options__(opts)

        # All helpers are public contracts and cannot be changed
        live "/", Phoenix.ExUssd.PageLive, :home, opts
      end
    end
  end

  def __options__(options) do
    live_socket_path = Keyword.get(options, :live_socket_path, "/live")

    contacts =
      case options[:contacts] do
        nil ->
          %{contacts: nil}
        contacts -> %{contacts: contacts}
      end
    session_args = [contacts]

    [
      session: {__MODULE__, :__session__, session_args},
      private: %{live_socket_path: live_socket_path},
      layout: {Phoenix.LiveDashboard.LayoutView, :dash},
      as: :live_dashboard
    ]
  end
  def __session__(conn, opts) do
    IO.inspect opts
    %{}
  end
end
