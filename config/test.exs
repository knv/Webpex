import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :webpex, WebpexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "OnmvUJyqoRYiSGa6tepHAdWE3WfXZhACzKXuZ87LxKYH9vi+7tOCsbWLkCQ9VIQQ",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
