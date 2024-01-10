defmodule Notes.Schema.Core.Notes do
  use Ecto.Schema
  import Ecto.Changeset

  schema("notes") do
    field(:title, :string)
    field(:note, :string)
    field(:priority, Priority)
    timestamps(type: :utc_datetime)
  end

  @permitted ~w(title note priority)a

  def changeset(%__MODULE__{} = notes, params) do
    notes
    |> cast(params, @permitted)
    |> validate_required(@permitted)
    |> unique_constraint(:title,
      name: :unique_title,
      message: "Note with this title is already there"
    )
  end
end
