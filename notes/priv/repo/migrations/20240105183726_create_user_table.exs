defmodule Notes.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS citext")

    create table("users") do
      add(:username, :string, null: false)
      add(:first_name, :string, null: false)
      add(:last_name, :string)
      add(:email, :citext, null: false)
      add(:password_hash, :string, null: false)
      timestamps(type: :timestamptz)
    end

    create unique_index("users", [:email], name: :unique_email_per_user)
    create unique_index("users", [:username], name: :unique_username_per_user)
  end

  def down do
    drop unique_index("users", [:email])
    drop unique_index("users", [:username])
    drop table("users")
  end
end
