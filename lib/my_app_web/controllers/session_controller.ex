defmodule MyAppWeb.SessionController do
  use MyAppWeb, :controller

  action_fallback MyAppWeb.FallbackController

  alias MyApp.{Accounts, Accounts.Guardian}

  def login(conn, %{"email" => email, "password_hash" => password_hash}) do
    case Accounts.authenticate_user(email, password_hash) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:ok)
        |> render(:user_token, user: user, token: token)

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_status(:ok)
    |> json(%{msg: "Logged out"})
  end
end
