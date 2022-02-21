defmodule BattleshipsInterfaceWeb.Presence do
  use Phoenix.Presence, otp_app: :ships_interface,
                        pubsub_server: BattleshipsInterface.PubSub
end
