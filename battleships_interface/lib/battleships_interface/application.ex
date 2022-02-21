defmodule BattleshipsInterface.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BattleshipsInterfaceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BattleshipsInterface.PubSub},
      # Start the Endpoint (http/https)
      BattleshipsInterfaceWeb.Endpoint
      # Start a worker by calling: BattleshipsInterface.Worker.start_link(arg)
      # {BattleshipsInterface.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BattleshipsInterface.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BattleshipsInterfaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
