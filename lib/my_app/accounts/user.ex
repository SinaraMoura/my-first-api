defmodule MyApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email)
    |> password_hash()
  end

  @doc false
  defp password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password_hash: password_hash}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password_hash))

      %Ecto.Changeset{valid?: true, changes: _} ->
        changeset

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end
end
