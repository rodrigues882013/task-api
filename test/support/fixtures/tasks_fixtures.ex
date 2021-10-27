defmodule TaskApi.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskApi.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        created_at: ~U[2021-10-10 22:48:00Z],
        description: "some description",
        id: "some id",
        name: "some name"
      })
      |> TaskApi.Tasks.create_task()

    task
  end
end
