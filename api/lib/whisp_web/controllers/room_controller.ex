defmodule WhispWeb.RoomController do
  use WhispWeb, :controller

  alias Whisp.Repo
  alias Whisp.Chats

  plug Guardian.Plug.EnsureAuthenticated, handler: WhispWeb.SessionController

  def index(conn, _params) do
    rooms = Chats.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    # changeset = Room.changeset(%Room{}, params)

    case Chats.create_room(params) do
      {:ok, room} ->
        assoc_changeset = Whisp.UserRoom.changeset(
          %Whisp.UserRoom{},
          %{user_id: current_user.id, room_id: room.id}
        )
        Repo.insert(assoc_changeset)

      conn
      |> put_status(:created)
      |> render("show.json", room: room)
    {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WhispWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def join(conn, %{"id" => room_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    room = Chats.get_room!(room_id)

    changeset = Whisp.UserRoom.changeset(
      %Whisp.UserRoom{},
      %{room_id: room.id, user_id: current_user.id})

    case Repo.insert(changeset) do
      {:ok, _user_room} ->
        conn
        |> put_status(:created)
        |> render("show.json", %{room: room})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WhispWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

end
