defmodule TaskApiWeb.Router do
  use TaskApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaskApiWeb do
    pipe_through :api

    get("/task", TaskController, :find_all)
    post("/task", TaskController, :save)
    get("/task/:id", TaskController, :find_one)
    put("/task/:id", TaskController, :save)
    delete("/task/:id", TaskController, :delete)
  end
end
