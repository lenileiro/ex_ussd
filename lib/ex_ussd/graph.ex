defmodule ExUssd.NavGraph do
  @moduledoc false

  use GenServer
  @name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def all(pid \\ @name), do: GenServer.call(pid, {:all})

  def add(pid \\ @name, menu), do: GenServer.cast(pid, {:add, menu})

  def path(pid \\ @name, parent, child), do: GenServer.cast(pid, {:path, parent, child})

  @impl true
  def init(_opts) do
    {:ok, Graph.new()}
  end

  @impl true
  def handle_call({:all}, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:add, %ExUssd{} = menu}, state) do
    {:noreply, state |> Graph.add_vertex(menu)}
  end

  @impl true
  def handle_cast({:path, %ExUssd{} = parent, %ExUssd{} = child}, state) do
    {:noreply, state |> Graph.add_edge(parent, child)}
  end
end
