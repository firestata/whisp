defmodule WhispWeb.MessageController do
	use WhispWeb, :controller

	import Ecto.Query

	alias Whisp.Chats

	plug Guardian.Plug.EnsureAuthenticated, handler: WhispWeb.SessionController

	def index(conn, params) do
		last_seen_id = params["last_seen_id"] || 0
		room = Chats.get_room!(params["room_id"])

		page =
		  Whisp.Message
		  |> where([m], m.room_id == ^room.id)
			|> where([m], m.id < ^last_seen_id)
			|> order_by([desc: :inserted_at, desc: :id])
			|> preload(:user)
			|> Whisp.Repo.paginate()

		render(conn, "index.json", %{messages: page.entries, pagination: Whisp.PaginationHelpers.pagination(page)})
	end

end
