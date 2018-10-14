defmodule WhispWeb.SessionView do
	use WhispWeb, :view

	def render("show.json", %{user: user, jwt: jwt}) do
		%{data: render_one(user, WhispWeb.UserView, "user.json"),
			meta: %{token: jwt}}
	end

	def render("error.json", _) do
		%{error: "Invalid email or password"}
	end

	def render("forbidden.json", %{error: error}) do
		%{error: error}
	end

end
