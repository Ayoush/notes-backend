defmodule NotesWeb.Router do
  use NotesWeb, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  pipeline :ensure_auth do
    plug(NotesWeb.AuthPipeline.EnsureAuth)
  end

  scope "/api", NotesWeb do
    pipe_through(:api)

    scope "/auth" do
      scope "/", Authentication do
        post("/signup", AuthController, :register)
        post("/login", AuthController, :login)
      end
    end
  end

  scope "/api", NotesWeb do
    pipe_through(:ensure_auth)

    scope "/core" do
      scope "/", Core do
        resources "/notes", NotesController, except: [:edit, :new]
      end
    end
  end

  # Enable Swoosh mailbox preview in development
  # if Application.compile_env(:notes, :dev_routes) do
  #   scope "/dev" do
  #     pipe_through [:fetch_session, :protect_from_forgery]

  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end
end
