import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :battleships_interface, BattleshipsInterfaceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "HdLDRlbYDvHx+z/gnxbo6M8RIIS/jG35ttO7gvpImZ4mrEnRi+baD9NJ1K0DVSYZ",
  server: false

# In test we don't send emails.
config :battleships_interface, BattleshipsInterface.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
