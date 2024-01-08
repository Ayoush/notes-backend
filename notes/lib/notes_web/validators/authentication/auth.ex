defmodule NotesWeb.Validators.Authentication.Auth do
  use Params

  defparams(
    verify_user_params(%{
      username!: :string,
      first_name!: :string,
      last_name: :string,
      password!: :string,
      password_confirmation!: :string,
      email!: :string
    })
  )

  defparams(
    verify_login_params(%{
      username!: :string,
      password!: :string
    })
  )
end
