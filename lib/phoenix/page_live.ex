defmodule Phoenix.ExUssd.PageLive do
  use Phoenix.ExUssd.Web, :live_view

  def render(assigns) do
    ~L"""
    Current temperature: <%= @temperature %>
    """
  end

  def mount(_params, _args, socket) do
    {:ok, assign(socket, :temperature, 10)}
  end
end
