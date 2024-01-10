defmodule NotesWeb.AuthPipeline.EnsureAuth do
  use Guardian.Plug.Pipeline,
    otp_app: :notes,
    module: Notes.Guardian,
    error_handler: NotesWeb.AuthPipeline.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug Guardian.Plug.EnsureAuthenticated
end
