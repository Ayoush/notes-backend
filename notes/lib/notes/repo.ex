defmodule Notes.Repo do
  use Ecto.Repo,
    otp_app: :notes,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
