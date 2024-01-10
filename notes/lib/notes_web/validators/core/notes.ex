defmodule NotesWeb.Validators.Core.Notes do
  use Params

  defparams(
    verify_notes_params(%{
      title!: :string,
      note!: :string,
      priority!: :string
    })
  )

  defparams(
    verify_id(%{
      id!: :integer
    })
  )
end
