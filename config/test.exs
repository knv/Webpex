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

config :webpex, :runtime,
  data_directory: "priv/test",  # should be an absolute path
  #token: 456e910f-3d07-470d-a862-1deb1494a38e # change it
  valid_image_qualities: [80, 90, 95, 100],
  valid_image_sizes: [ {300,300}, {500,500} ]
