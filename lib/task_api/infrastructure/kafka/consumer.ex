defmodule TaskApi.Infrastructure.Kafka.Consumer do
  use KafkaEx.GenConsumer

  alias TaskApi.Infrastructure.Cassandra.TaskRepository
  alias KafkaEx.Protocol.Fetch.Message

  require Logger

  def handle_message_set(message_set, state) do
    for %Message{value: message} <- message_set do
      process(Jason.decode(message))
    end

    {:async_commit, state}
  end

  defp process({:ok, %{"operation" => "DELETE", "payload" => %{"id" => id}}}),
    do: TaskRepository.delete(id)

  defp process({:ok, %{"payload" => payload}}), do: TaskRepository.save(payload)

  defp process({:error, message}), do: IO.inspect(message)
end
