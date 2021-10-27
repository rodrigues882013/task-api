# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :task_api, TaskApiWeb.Endpoint,
  url: [ip: {0, 0, 0, 0}, port: 4000],
  render_errors: [view: TaskApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: TaskApi.PubSub,
  live_view: [signing_salt: "TA00sqk7"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kafka_ex,
  brokers: System.get_env("ENV_KAFKA") || "localhost:9092",
  sync_timeout: 3000,
  max_restarts: 10,
  max_seconds: 60,
  commit_interval: 5_000,
  commit_threshold: 100,
  sleep_for_reconnect: 400,
  kafka_version: "kayrock",

  # Consumer Specific configuration
  consumer_group_name: "task-consumer-group",
  topic_names: System.get_env("ENV_TOPICS") || ["task_notification"],
  gen_consumer_impl: TaskApi.Infrastructure.Kafka.Consumer,
  consumer_group_opts: [
    # setting for the ConsumerGroup
    heartbeat_interval: 1_000,
    # this setting will be forwarded to the GenConsumer
    commit_interval: 1_000
  ]

config :xandra, Xandra,
  name: TaskCluster,
  pool: Xandra.Cluster,
  underlying_pool: DBConnection.Poolboy,
  pool_size: 10,
  nodes: [System.get_env("ENV_CASSANDRA") || "localhost:9042"],
  after_connect: &Xandra.execute!(&1, "USE task_keyspace")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
