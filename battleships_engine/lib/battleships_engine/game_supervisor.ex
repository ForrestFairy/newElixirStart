defmodule BattleshipsEngine.GameSupervisor do
  use DynamicSupervisor

  alias BattleshipsEngine.Game

  def start_link(_options), do:
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do:
    DynamicSupervisor.init(strategy: :one_for_one)

  def start_game(name) do
    spec = %{id: Game, start: {Game, :start_link, [name]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_game(name) do
    :ets.delete(:game_state, name)
    DynamicSupervisor.terminate_child(__MODULE__, pid_from_name(name))
  end

  def pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.whereis()
  end
end
