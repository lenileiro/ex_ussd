defmodule ExUssd.Registry do
  use GenServer
  def init(_opts), do: {:ok, %{routes: [], current_menu: nil, home_menu: nil}}

  defp via_tuple(session_id), do: {:via, Registry, {:session_registry, session_id}}

  def start(session) do
    name = via_tuple(session)
    Phoenix.PubSub.subscribe(ExUssd.PubSub, session)
    GenServer.start_link(__MODULE__, 0, name: name)
    :ok
  end

  def lookup(session) do
    case Registry.lookup(:session_registry, session) do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, :not_found}
    end
  end

  def stop(session) do
    case lookup(session) do
      {:ok, pid} -> Process.exit(pid, :shutdown)
      _ -> {:error, :not_found}
    end
  end
end
