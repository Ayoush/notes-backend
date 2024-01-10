defmodule NotesWeb.Core.NotesJSON do
  def render("create.json", %{note: note}) do
    %{title: note.title, note: note.note, priority: note.priority}
  end
end
