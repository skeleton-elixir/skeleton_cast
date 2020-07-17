defmodule Skeleton.Cast.EmailTest do
  use Skeleton.Cast.TestCase
  alias Skeleton.App.User
  import Skeleton.Cast.Email

  describe "Validating" do
    test "valid email" do
      [
        "email@example.com",
        "email+234@example.net",
        "email_234@example.com.br",
        "email.234@example.com"
      ]
      |> Enum.each(fn email ->
        changeset = cast(email)
        assert changeset.valid?
        assert changeset.changes[:email]
      end)
    end

    test "invalid email" do
      [
        "emailexample.com",
        "email@@example.com",
        "email @example.com",
        "@example.com"
      ]
      |> Enum.each(fn email ->
        changeset = cast(email)
        refute changeset.valid?
        assert changeset.errors == [email: {"has invalid format", [validation: :format]}]
      end)
    end
  end

  describe "Requiring email" do
    test "valid email" do
      changeset = cast("email@example.com", required: true)
      assert changeset.valid?
      assert changeset.changes[:email]
    end

    test "requires when email is blank" do
      changeset = cast("", required: true)
      refute changeset.valid?
      assert changeset.errors == [email: {"can't be blank", [validation: :required]}]
    end

    test "requires when email is nil" do
      changeset = cast(nil, required: true)
      refute changeset.valid?
      assert changeset.errors == [email: {"can't be blank", [validation: :required]}]
    end
  end

  defp cast(email, opts \\ []) do
    %User{}
    |> cast(%{email: email}, [])
    |> cast_email(:email, opts)
  end
end
