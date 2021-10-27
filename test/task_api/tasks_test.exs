defmodule TaskApi.TasksTest do
  use TaskApi.DataCase

  alias TaskApi.Tasks

  describe "tasks" do
    alias TaskApi.Tasks.Task

    import TaskApi.TasksFixtures

    @invalid_attrs %{created_at: nil, description: nil, id: nil, name: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{
        created_at: ~U[2021-10-10 22:48:00Z],
        description: "some description",
        id: "some id",
        name: "some name"
      }

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.created_at == ~U[2021-10-10 22:48:00Z]
      assert task.description == "some description"
      assert task.id == "some id"
      assert task.name == "some name"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()

      update_attrs = %{
        created_at: ~U[2021-10-11 22:48:00Z],
        description: "some updated description",
        id: "some updated id",
        name: "some updated name"
      }

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.created_at == ~U[2021-10-11 22:48:00Z]
      assert task.description == "some updated description"
      assert task.id == "some updated id"
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
