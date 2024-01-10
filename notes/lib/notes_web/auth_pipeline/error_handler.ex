defmodule NotesWeb.AuthPipeline.ErrorHandler do
  use NotesWeb, :controller
  import Hammer

  def auth_error(conn, {type, _reason}, _opts) do
    case check_rate(conn.remote_ip, 60000, 30) do
      {:allow, _params} ->
        conn
        |> put_status(403)
        |> put_view(NotesWeb.ErrorHelpers)
        |> render("403.json", message: to_string(type))
      {:deny, _count} ->
        conn
        |> put_status(429)
        |> put_view(NotesWeb.ErrorHelpers)
        |> render("403.json", message: "Rate Limit Reached")
    end
  end
end
