defmodule NotesWeb.Authentication.AuthController do
  use NotesWeb, :controller
  import NotesWeb.Validators.Authentication.Auth
  import NotesWeb.Helpers
  alias Notes.Parsers.Authentication.AuthParser

  def register(conn, params) do
    case conn.status do
      nil ->
        changeset = verify_user_params(params)

        with {:extract, {:ok, data}} <- {:extract, extract_changeset_data(changeset)},
             {:create, {:ok, user}} <- {:create, AuthParser.create(data)} do
          conn
          |> put_status(200)
          |> render("register.json", %{user: user})
        else
          {:extract, {:error, error}} ->
            send_error(conn, 400, error)

          {:create, {:error, message}} ->
            send_error(conn, 400, message.error)
        end
    end
  end

  def login(conn, params) do
    case conn.status do
      nil ->
        changeset = verify_login_params(params)

        with {:extract, {:ok, data}} <- {:extract, extract_changeset_data(changeset)},
             {:create, {:ok, access_token, _refresh_token}} <- {:create, AuthParser.login(data)} do
          conn
          |> put_status(200)
          |> put_resp_header("Authorization", "Bearer #{access_token}")
          |> render("login.json")
        else
          {:extract, {:error, error}} ->
            send_error(conn, 400, error)

          {:create, {:error, message}} ->
            send_error(conn, 400, message.error)
        end
    end
  end
end
