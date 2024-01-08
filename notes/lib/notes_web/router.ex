defmodule NotesWeb.Router do
  use NotesWeb, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", NotesWeb do
    scope "/auth" do
      scope "/", Authentication do
        post("/signup", AuthController, :register)
        post("/login", AuthController, :login)
      end
    end
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:notes, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
