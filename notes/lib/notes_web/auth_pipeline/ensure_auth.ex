defmodule NotesWeb.AuthPipeline.EnsureAuth do
  use Guardian.Plug.Pipeline,
    otp_app: :notes,
    module: Notes.Guardian,
    error_handler: NotesWeb.AuthPipeline.ErrorHandler

  plug Guardian.Plug.EnsureAuthenticated

end
