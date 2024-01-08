defmodule Notes.Schema.Authentication.Users do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt
  @password_min_length 8

  schema("users") do
    field(:username, :string)
    field(:first_name, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:last_name, :string)
    field(:email, :string)
    field(:password_hash, :string)
    timestamps(type: :utc_datetime)
  end

  @required ~w(username first_name email password_hash)a
  @optional ~w(last_name password password_confirmation)a
  @permitted @required ++ @optional

  def changeset(%__MODULE__{} = user_cred, params) do
    user_cred
    |> cast(params, @permitted)
    |> validate_confirmation(:password)
    |> validate_length(:password, min: @password_min_length)
    |> validate_confirmation(:password_confirmation)
    |> validate_length(:password, min: @password_min_length)
    |> put_pass_hash()
    |> validate_required(@required)
    |> unique_constraint(:email,
      name: :unique_email_per_user,
      message: "Email already registered"
    )
    |> unique_constraint(:username,
      name: :unique_username_per_user,
      message: "Username already exists"
    )
  end

  def update(%__MODULE__{} = user, params) do
    user
    |> cast(params, @permitted)
    |> validate_required(@required)
    |> unique_constraint(:email, name: :unique_email_per_user)
    |> unique_constraint(:username, name: :unique_username_per_user)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true} = changeset) do
    with {:password, {:ok, password}} <- {:password, fetch_change(changeset, :password)},
         {:password_confirmation, {:ok, confirm_password}} <-
           {:password_confirmation, fetch_change(changeset, :password_confirmation)} do
      case password == confirm_password do
        true ->
          password_hash = generate_hash(password)

          changeset
          |> put_change(:password_hash, password_hash)
          |> delete_change(:password)
          |> delete_change(:password_confirmation)

        false ->
          changeset
      end
    end
  end

  defp put_pass_hash(changeset), do: changeset

  defp generate_hash(password) do
    Bcrypt.hash_pwd_salt(password)
  end
end
