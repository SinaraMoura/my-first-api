defmodule MyApp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyApp.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@email.com",
        password_hash: "password"
      })
      |> MyApp.Accounts.create_user()

    user
  end
end
