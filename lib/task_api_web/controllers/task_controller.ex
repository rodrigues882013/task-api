defmodule TaskApiWeb.TaskController do
  use TaskApiWeb, :controller

  alias TaskApi.Infrastructure.Kafka.Producer

  def find_one(conn, %{"id" => _id}) do
    conn
    |> put_status(202)
    |> json(%{"name" => "Teste"})
  end

  def save(conn, %{"id" => _} = payload) do
    %{"payload" => payload, "operation" => :UPDATE}
    |> Producer.send_message()
    |> handle_result(conn, payload)
  end

  def save(conn, payload) do
    %{"payload" => payload, "operation" => :CREATE}
    |> Producer.send_message()
    |> handle_result(conn, payload)
  end

  def find_all(conn, _params) do
    conn
    |> put_status(202)
    |> json(%{"name" => "Teste"})
  end

  def delete(conn, %{"id" => _} = payload) do
    %{"payload" => payload, "operation" => :DELETE}
    |> Producer.send_message()
    |> handle_result(conn, payload)
  end

  defp handle_result({:error, message}, conn, _) do
    conn
    |> put_status(202)
    |> json(%{"error" => message})
  end

  defp handle_result(:ok, conn, payload) do
    conn
    |> put_status(202)
    |> json(payload)
  end
end
