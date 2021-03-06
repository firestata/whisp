defmodule WhispWeb.Router do
  use WhispWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", WhispWeb do
    pipe_through :api

    post "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
    post "/sessions/refresh", SessionController, :refresh
    resources "/users", UserController, only: [:create]

		get "/users/:id/rooms", UserController, :rooms
		resources "/rooms", RoomController, only: [:index, :create]
		post "/rooms/:id/join", RoomController, :join
  end

end
