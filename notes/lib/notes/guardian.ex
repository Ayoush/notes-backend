defmodule Notes.Guardian do
  use Guardian, otp_app: :notes

  def subject_for_token(nil, _) do
    {:error, :resource_not_found}
  end

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(nil) do
    {:error, :no_claims_found}
  end

  def resource_from_claims(claims) do
    user_id = claims["sub"]
    {:ok, user_id}
  end
end
