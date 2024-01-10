defmodule NotesWeb.Core.NotesController do
  use NotesWeb, :controller
  import Hammer
  import NotesWeb.Helpers
  import NotesWeb.Validators.Core.Notes
  alias Notes.Parsers.Core.NotesParser

  def create(conn, params) do
    case check_rate(conn.remote_ip, 60000, 10) do
      {:allow, count} ->
        changeset = verify_notes_params(params)

        with {:extract, {:ok, data}} <- {:extract, extract_changeset_data(changeset)},
             {:create, {:ok, note}} <- {:create, NotesParser.create(data)} do
          conn
          |> put_status(200)
          |> put_resp_header("X-Rate-Limit-Limit", "10")
          |> put_resp_header("X-Rate-Limit-Remaining", "#{10 - count}")
          |> put_resp_header(
            "X-Rate-Limit-Reset",
            "#{NotesParser.inspect_bucket(conn.remote_ip)}"
          )
          |> render("create.json", %{note: note})
        else
          {:extract, {:error, error}} ->
            send_error(conn, 400, error)

          {:create, {:error, message}} ->
            send_error(conn, 400, message.error)
        end

      {:deny, _count} ->
        send_error(conn, 429, %{error: "You have exceeded the rate limit"})
    end
  end

  # YET TO BE IMPLEMENTED
  # def show(conn, params) do
  #   IEx.pry()
  # end

  # def index(conn, params) do
  #   IEx.pry()
  # end

  # def update(conn, params) do
  #   IEx.pry()
  # end

  # def delete(conn, params) do
  #   IEx.pry()
  # end

  def search
end
