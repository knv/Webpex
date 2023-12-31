import Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :webpex, WebpexWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "Y8ySVSRJGphg+T3UG6xuRu/Mgc3d6QG+etlJEodKEIjmSQtjE78v9e/rGyeCZzxZ",
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Enable dev routes for dashboard and mailbox
config :webpex, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :webpex, :runtime,
  #data_directory: "priv/test",  # should be an absolute path
  data_directory: System.get_env("DATA_DIRECTORY"),  # should be an absolute path
  #server_address: 127.0.0.1:8080
  #token: "456e910f-3d07-470d-a862-1deb1494a38e" # change it
  #default_image_quality: 95
  valid_image_qualities: [80, 90, 95, 100],
  valid_image_sizes: [ {300,300}, {500,500} ]
  #max_uploaded_image_size: 4 # in megabytes
  #http_cache_ttl: 2592000 # in seconds. default is 1 month.
  #log_path: null # default is null and logs to console
  #debug: false
