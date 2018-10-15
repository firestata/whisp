defmodule WhispWeb.SessionController do
	use WhispWeb, :controller

	alias Whisp.Repo

	@token_ttl_in_days 30

	def create(conn, params) do
		case authenticate(params) do
			{:ok, user} ->
				new_conn = Guardian.Plug.api_sign_in(conn, user, :access)
				jwt = Guardian.Plug.current_token(new_conn)

				new_conn
				|> put_status(:created)
				|> render("show.json", user: user, jwt: jwt)
			:error ->
				conn
				|> put_status(:unauthorized)
				|> render("error.json")
		end
	end

	def delete(conn, _) do
		jwt = Guardian.Plug.current_token(conn)
		Guardian.revoke!(jwt)

		conn
		|> put_status(:ok)
		|> render("delete.json")
	end

	def refresh(conn, _params) do
		user = Guardian.Plug.current_resource(conn)
		jwt = Guardian.Plug.current_token(conn)
		{:ok, claims} = Guardian.Plug.claims(conn)

		case Guardian.refresh!(jwt, claims, %{ttl: {@token_ttl_in_days, :days}}) do
			{:ok, new_jwt, _new_claims} ->
				conn
				|> put_status(:ok)
				|> render("show.json", user: user, jwt: new_jwt)
			{:error, _reason} ->
				conn
				|> put_status(:unauthorized)
				|> render("forbidden.json", error: "Not authenticated")
		end
	end

	def unauthenticated(conn, _params) do
		conn
		|> put_status(:forbidden)
		|> render(WhispWeb.SessionView, "forbidden.json", error: "Not authenticated")
	end

	defp authenticate(%{"email" => email, "password" => password}) do
		user = Repo.get_by(Whisp.Account.User, email: String.downcase(email))

		case check_password(user, password) do
			true -> {:ok, user}
			_ -> :error
		end
	end

	defp check_password(user, password) do
		case user do
			nil -> Comeonin.Bcrypt.dummy_checkpw()
			_ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
		end
	end

end
