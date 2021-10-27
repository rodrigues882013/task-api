defmodule TaskApi.Infrastructure.Cassandra.TaskRepository do
  alias Xandra

  def find(payload) do
    prepared = Xandra.prepare!(TaskCluster, "SELECT * FROM tasks WHERE id=?")
    Xandra.execute(TaskCluster, prepared, [Map.get(payload, "id")])
  end

  def save(payload) do
    prepared =
      Xandra.prepare!(
        TaskCluster,
        "INSERT INTO tasks (id, definition, metadata) VALUES (?, ?, ?)"
      )

    Xandra.execute(TaskCluster, prepared, [
      get_id(),
      Map.get(payload, "definition"),
      Jason.encode!(Map.get(payload, "metadata"))
    ])
  end

  def delete(id) do
    prepared = Xandra.prepare!(TaskCluster, "DELETE FROM tasks WHERE id=?")
    Xandra.execute(TaskCluster, prepared, [id])
  end

  defp get_id() do
    random =
      (:io_lib.format("~11..0B", [:rand.uniform(10_000_000_000) - 1]) |> to_string) <>
        Integer.to_string(:os.system_time(:millisecond))

    :crypto.hash(:md5, random)
    |> Base.encode64()
    |> String.replace("==", "")
  end
end
