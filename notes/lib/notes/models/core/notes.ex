defmodule Notes.Models.Core.Notes do
  alias Notes.Repo
  alias Notes.Schema.Core.Notes

  def create(params) do
    changeset = Notes.changeset(%Notes{}, params)

    case Repo.insert(changeset) do
      {:ok, note} -> {:ok, note}
      {:error, message} -> {:error, message}
    end
  end
end
