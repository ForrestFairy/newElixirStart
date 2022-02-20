defmodule BattleshipsEngine.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Registry.Game},
      BattleshipsEngine.GameSupervisor
    ]

    opts = [strategy: :one_for_one, name: BattleshipsEngine.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
