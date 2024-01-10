defmodule Notes.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table("notes") do
      add :title, :string, null: false
      add :note, :text, null: false
      add :priority, Priority.type(), null: false

      timestamps(type: :timestamptz)
    end

    create unique_index("notes", [:title], name: :unique_title)
  end
end
