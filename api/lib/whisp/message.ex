defmodule Whisp.Message do
  use Ecto.Schema
  import Ecto.Changeset


  schema "messages" do
    field :text, :string
    belongs_to :room, Whisp.Chats.Room
    belongs_to :user, Whisp.Account.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :user_id, :room_id])
    |> validate_required([:text, :user_id, :room_id])
  end
end
