# Hedwig Brain

Simple key-value persistence for Hedwig responders, `Hedwig.Brain` stores lists of arbitrary terms under binary keys. Optionally, you may persist state to Redis for data durability across crashes and restarts.

## Usage

```elixir
alias Hedwig.Brain

# Store lists under binary keys:
iex> Brain.set("people", ["Ada", "Babbage"])

# Retrieve lists by key:
iex> Brain.get("people")
["Ada", "Babbage"]

# Delete lists. Lists at missing keys are empty:
iex> Brain.delete("people")
iex> Brain.get("people")
[]

# Append items to lists:
iex> Brain.add("people", %{first: "Ada", last: "Byron"})
iex> Brain.get("people")
%{first: "Ada", last: "Byron"}

# Delete items from lists:
iex> Brain.set("people", ["Ada", "Babbage"])
iex> Brain.remove("people", "Ada")
iex> Brain.get("people")
"Babbage"

# Retrieve items by index:
iex> Brain.set("people", ["Ada", "Babbage"])
iex> Brain.at_index("people", 0)
"Ada"
```

## Installation

Until this library is made available on Hex.pm, you’ll need to load it from Github:

```elixir
def deps do
  [
    {:hedwig_brain, github: "stevegrossi/hedwig_brain"}
  ]
end
```

Then, you can start the `Brain` process manually:

```elixir
{:ok, pid} = Hedwig.Brain.start_link
```

or as part of your application’s supervision tree:

```elixir
children = [
  worker(Hedwig.Brain, [])
]
```

Note that the `Brain` process is named, so you cannot run more than one instance of it.

## In Production

By default, the `Brain` uses an in-memory `ProcessStore`—implemented as an `Agent`—to hold state. As a result, all state is lost when the process crashes or is restarted. To persist state to disk so that it survives restarts, you can configure the `Brain` to store state in Redis:

    config :hedwig_brain, :store, Hedwig.Brain.RedisStore

The `RedisStore` will expect Redis to be running on the default host and port, `localhost:6379`. This can be overridden by either the `REDIS_URL` environment variable, or else `config :hedwig_brain, :redis_url` in the configuration file.

## Testing

The tests for `hedwig_brain` require Redis to be running on the default host and port. They call `FLUSHDB` on database 3 before each test. The default Redis database is 0, but know that if you’re using database 3 locally, its data *will be wiped* by `mix test`.
