defmodule NotesWeb.Authentication.AuthJSON do
  use NotesWeb, :view

  def render("register.json", %{user: user}) do
    %{
      username: user.username,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      updated_at: user.updated_at,
      inserted_at: user.inserted_at
    }
  end

  def render("login.json", _params) do
    %{
      message: "Successfully loged in"
    }
  end
end
