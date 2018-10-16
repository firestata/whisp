defmodule Whisp.Chats.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :name, :string
    field :topic, :string
    many_to_many :users, Whisp.Account.User, join_through: "user_rooms"
    has_many :messages, Whisp.Message

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :topic])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
