defmodule Notes.Parsers.Core.NotesParser do
  import NotesWeb.Helpers
  import Hammer
  alias Notes.Models.Core.Notes, as: NotesModel

  def inspect_bucket(bucket_name) do
    with {:ok, {_count, _remaining, _params, _start_time, reset_time}} <-
           inspect_bucket(bucket_name, 60000, 10) do
      reset_time
    else
      {:error, _reason} ->
        nil
    end
  end

  def create(params) do
    %{title: title, note: note, priority: priority} = params
    verify_create(NotesModel.create(%{title: title, note: note, priority: priority}))
  end

  defp verify_create({:ok, note}) do
    {:ok, %{title: note.title, note: note.note, priority: note.priority}}
  end

  defp verify_create({:error, reason}) do
    {:error, %{error: extract_changeset_error(reason)}}
  end
end
