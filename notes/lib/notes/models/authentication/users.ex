defmodule Notes.Models.Authentication.Users do
  import Ecto.Query
  alias Notes.Repo
  alias Notes.Schema.Authentication.Users, as: UserSchema
  alias Notes.Models.Helpers, as: ModelHelpers

  def create(params) do
    changeset = UserSchema.changeset(%UserSchema{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, user}

      {:error, message} ->
        {:error, message}
    end
  end

  def update(user, params) do
    changeset = UserSchema.update(user, params)

    case Repo.update(changeset) do
      {:ok, user} ->
        {:ok, user}

      {:error, message} ->
        {:error, message}
    end
  end

  def get(id, preloads) when is_integer(id) do
    case Repo.get(UserSchema, id) do
      nil ->
        {:error, "not found"}

      user ->
        user = Repo.preload(user, preloads)
        {:ok, user}
    end
  end

  # for fetching the users based on username
  def get(username) when is_binary(username) do
    query =
      from user in UserSchema,
        where: user.username == ^username

    verify_username_query(Repo.one(query))
  end

  defp verify_username_query(%UserSchema{} = user) do
    {:ok, user}
  end

  defp verify_username_query(nil) do
    {:error, "User with this username doesn't exists"}
  end

  def get_all(%{page_size: page_size, page_number: page_number}) do
    UserSchema |> order_by(:id) |> Repo.paginate(page: page_number, page_size: page_size)
  end

  def get_all(%{page_size: page_size, page_number: page_number}, preloads) do
    paginated_user_data =
      UserSchema |> order_by(:id) |> Repo.paginate(page: page_number, page_size: page_size)

    user_data_with_preloads = paginated_user_data.entries |> Repo.preload(preloads)

    ModelHelpers.paginated_response(user_data_with_preloads, paginated_user_data)
  end

  def delete(user, preloads) do
    case Repo.delete(user) do
      {:ok, user} ->
        {:ok, user |> Repo.preload(preloads)}

      {:error, message} ->
        {:error, message}
    end
  end

  def delete(user) do
    case Repo.delete(user) do
      {:ok, user} ->
        {:ok, user}

      {:error, message} ->
        {:error, message}
    end
  end
end
