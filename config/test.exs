use Mix.Config

# Since 0 is the default database for Redis, we use a non-default database so as
# to avoid unintentionally wiping peoples’ data when they run the tests.
config :hedwig_brain, :redis_url, "redis://localhost:6379/3"
