defmodule WhispWeb.Router do
  use WhispWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WhispWeb do
    pipe_through :api
  end
end
