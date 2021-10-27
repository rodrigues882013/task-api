defmodule TaskApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :id, :string
      add :name, :string
      add :description, :string
      add :created_at, :utc_datetime

      timestamps()
    end
  end
end
