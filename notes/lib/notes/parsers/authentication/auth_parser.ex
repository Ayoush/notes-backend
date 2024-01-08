defmodule Notes.Parsers.Authentication.AuthParser do
  import NotesWeb.Helpers
  alias Bcrypt
  alias Notes.Models.Authentication.Users, as: UserModel
  alias Notes.Guardian

  @access_time_hours 5
  @refresh_time_weeks 1

  def create(params) do
    %{
      username: username,
      first_name: first_name,
      last_name: last_name,
      password: password,
      password_confirmation: password_confirmation,
      email: email
    } = params

    verify_user(
      UserModel.create(%{
        username: username,
        first_name: first_name,
        last_name: last_name,
        password: password,
        password_confirmation: password_confirmation,
        email: email
      })
    )
  end

  defp verify_user({:ok, user}) do
    {:ok,
     %{
       username: user.username,
       first_name: user.first_name,
       last_name: user.last_name,
       email: user.email,
       updated_at: user.updated_at,
       inserted_at: user.inserted_at
     }}
  end

  defp verify_user({:error, user}) do
    {:error, %{error: extract_changeset_error(user)}}
  end

  def login(params) do
    with {:ok, user} <- UserModel.get(params.username) do
      params.password
      |> Bcrypt.verify_pass(user.password_hash)
      |> case do
        true ->
          verify_token(generate_token(user))

        false ->
          {:error, %{error: "Password is wrong. Please try again"}}
      end
    else
      {:error, message} ->
        {:error, %{error: message}}
    end
  end

  defp generate_token(user) do
    with {:ok, access_token, _} <- create_jwt_token(user, @access_time_hours, :access, :hour),
         {:ok, refresh_token, _} <- create_jwt_token(user, @refresh_time_weeks, :refresh, :week) do
      {:ok, access_token, refresh_token}
    else
      {:error, _reason, _} ->
        {:error, "Invalid credentials"}
    end
  end

  def create_jwt_token(resource, time, token_type, time_sanitization) do
    Guardian.encode_and_sign(
      resource,
      token_type: token_type,
      ttl: [time, time_sanitization]
    )
  end

  defp verify_token({:ok, access_token, refresh_token}) do
    {:ok, access_token, refresh_token}
  end

  defp verify_token(_) do
    {:error, %{error: "Invalid credentials"}}
  end
end
