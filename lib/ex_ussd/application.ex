defmodule ExUssd.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ExUssd.Worker.start_link(arg)
      # {ExUssd.Worker, arg}
      {Registry, keys: :unique, name: :session_registry},
      # Start the Telemetry supervisor
      ExUssdWeb.Telemetry,
      {Phoenix.PubSub, name: ExUssd.PubSub},
      # Start the Endpoint (http/https)
      ExUssdWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExUssd.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExUssdWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
