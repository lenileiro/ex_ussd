# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :ex_ussd, ExUssdWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "maymsEeMiEB1aBFW6B9xcAr+8ZtLbbWiXOZRa9wLYO+QD8C6I+33yNPNeoLSZ3Xj",
  render_errors: [view: ExUssdWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExUssd.PubSub,
  live_view: [signing_salt: "9CAKIW8X"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
