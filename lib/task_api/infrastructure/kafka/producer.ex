defmodule TaskApi.Infrastructure.Kafka.Producer do
  alias KafkaEx
  alias UUID

  def send_message(payload) do
    message = %KafkaEx.Protocol.Produce.Message{
      key: UUID.uuid1(),
      value: Jason.encode!(payload),
      timestamp: :os.system_time(:millisecond)
    }

    produce_request = %KafkaEx.Protocol.Produce.Request{
      topic: Application.get_env(:kafka_ex, :topic_names) |> Enum.at(0),
      partition: 0,
      required_acks: 1,
      compression: :gzip,
      messages: [message],
      api_version: 3
    }

    KafkaEx.produce(produce_request) |> handle_result
  end

  def handle_result(:ok), do: :ok
  def handle_result({:ok, _}), do: :ok
  def handle_result({:error, message}), do: {:error, message}
  def handle_result(any), do: {:error, any}
end
