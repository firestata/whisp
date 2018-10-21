defmodule WhispWeb.RoomChannel do
	use WhispWeb, :channel

	import Ecto.Query

	alias Whisp.Repo
	alias Whisp.Chats

	def join("rooms:" <> room_id, _params, socket) do
		room = Chats.get_room!(room_id)

    page =
      Whisp.Message
      |> where([m], m.room_id == ^room.id)
      |> order_by([desc: :inserted_at, desc: :id])
      |> preload(:user)
      |> Repo.paginate()
		response = %{
			room: Phoenix.View.render_one(room, WhispWeb.RoomView, "room.json"),
			messages: Phoenix.View.render_many(page.entries, WhispWeb.MessageView, "message.json"),
			pagination: Whisp.PaginationHelpers.pagination(page)}

		IO.inspect response

		# send(self(), :after_join)
		{:ok, response, assign(socket, :room, room)}
	end

	def handle_in("new_message", params, socket) do
		changeset =
		  socket.assigns.room
		  |> Ecto.build_assoc(:messages, user_id: socket.assigns.current_user.id)
			|> Whisp.Message.changeset(params)

	  case Repo.insert(changeset) do
			{:ok, message} ->
				broadcast_message(socket, message)
				{:reply, :ok, socket}
			{:error, changeset} ->
				{:reply, {:error, Phoenix.View.render(WhispWeb.ChangesetView, "error.json", changeset)}, socket}
		end
	end

	# def handle_info(:join_after, socket) do
	#  # TODO: handle presence
	# end

	def terminate(_reason, socket) do
		{:ok, socket}
	end

	defp broadcast_message(socket, message) do
		message = Repo.preload(message, :user)
		rendered_message = Phoenix.View.render_one(message, WhispWeb.MessageView, "message.json")
		broadcast!(socket, "message_created", rendered_message)
	end

end
