defmodule TaskApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start the Telemetry supervisor
      TaskApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TaskApi.PubSub},
      # Start the Endpoint (http/https)
      TaskApiWeb.Endpoint,
      {Xandra, Application.fetch_env!(:xandra, Xandra)},
      supervisor(
        KafkaEx.ConsumerGroup,
        [
          Application.get_env(:kafka_ex, :gen_consumer_impl),
          Application.get_env(:kafka_ex, :consumer_group_name),
          Application.get_env(:kafka_ex, :topic_names),
          Application.get_env(:kafka_ex, :consumer_group_opts)
        ]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaskApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TaskApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
