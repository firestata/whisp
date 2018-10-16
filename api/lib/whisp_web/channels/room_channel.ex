defmodule WhispWeb.RoomChannel do
	use WhispWeb, :channel

  alias Whisp.Repo

	def join("rooms:" <> room_id, _params, socket) do
		room = Whisp.Chats.get_room!(room_id)

		response = %{room: Phoenix.View.render_one(room, WhispWeb.RoomView, "room.json")}

		{:ok, response, assign(socket, :room, room)}
	end

	def terminate(_reason, socket) do
		{:ok, socket}
	end

end
