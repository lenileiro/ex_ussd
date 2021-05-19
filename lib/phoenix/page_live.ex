defmodule Phoenix.ExUssd.PageLive do
  use Phoenix.ExUssd.Web, :live_view

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <button phx-click="start" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
      start session
      </button>
      <div class="mt-2 text-xl font-normal emphasis-high h-1">
        <%= Phoenix.HTML.Format.text_to_html(@menu_string) %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, %{"menu" => menu, "phone_numbers" => phone_numbers}, socket) do
    socket =
      socket
      |> assign(menu_string: "")
      |> assign(menu: menu)
      |> assign(phone_numbers: phone_numbers)

    {:ok, socket}
  end

  @impl true
  def handle_event("start", _, socket) do
    session_id = ExUssd.Utils.generate_id()

    api_parameters = %{
      # TODO: From simulator
      "service_code" => "*544#",
      "session_id" => session_id,
      "text" => "",
      "phone_number" => Enum.random(socket.assigns.phone_numbers)
    }

    {:ok, %{menu_string: menu_string, should_close: _should_close}} =
      ExUssd.goto(menu: socket.assigns.menu, api_parameters: api_parameters)

    socket =
      socket
      |> assign(menu_string: menu_string)
      |> assign(session_id: session_id)

    {:noreply, socket}
  end
end
