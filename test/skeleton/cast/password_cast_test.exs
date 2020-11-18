defmodule Skeleton.Cast.PasswordTest do
  use Skeleton.Cast.TestCase
  alias Skeleton.App.User
  import Skeleton.Cast.Password

  describe "Validating default regexp password" do
    test "valid password" do
      changeset = cast("Ab,11111")
      assert changeset.valid?
      assert changeset.changes[:password]
    end

    test "invalid password" do
      changeset = cast("1111")
      refute changeset.valid?
      assert changeset.errors == [password: {"has invalid format", [validation: :format]}]
    end
  end

  describe "Validating password require downcase characters" do
    test "valid password" do
      changeset = cast("a11111111", downcase: true)
      assert changeset.valid?
      assert changeset.changes[:password]
    end

    test "invalid password" do
      changeset = cast("11111111", downcase: true)
      refute changeset.valid?
      assert changeset.errors == [password: {"has invalid format", [validation: :format]}]
    end
  end

  describe "Validating password require uppercase characters" do
    test "valid password" do
      changeset = cast("A11111111", uppercase: true)
      assert changeset.valid?
      assert changeset.changes[:password]
    end

    test "invalid password" do
      changeset = cast("A11111111", downcase: true)
      refute changeset.valid?
      assert changeset.errors == [password: {"has invalid format", [validation: :format]}]
    end
  end

  describe "Validating password require number" do
    test "valid password" do
      changeset = cast("abcdefgh1", number: true)
      assert changeset.valid?
      assert changeset.changes[:password]
    end

    test "invalid password" do
      changeset = cast("abcdefghj", number: true)
      refute changeset.valid?
      assert changeset.errors == [password: {"has invalid format", [validation: :format]}]
    end
  end

  describe "Validating password size" do
    test "valid password" do
      changeset = cast("abc", size: 3)
      assert changeset.valid?
      assert changeset.changes[:password]
    end

    test "invalid password" do
      changeset = cast("a", number: true)
      refute changeset.valid?
      assert changeset.errors == [password: {"has invalid format", [validation: :format]}]
    end
  end

  describe "Validating password with all options enabled" do
    test "valid password" do
      changeset = cast("abcdefghij1-L", size: 10, number: true, uppercase: true, downcase: true, character: true)
      assert changeset.valid?
      assert changeset.changes[:password]
    end

    test "invalid password" do
      changeset = cast("abcdefghij1cL", size: 10, number: true, uppercase: true, downcase: true, character: true)
      refute changeset.valid?
      assert changeset.errors == [password: {"has invalid format", [validation: :format]}]
    end
  end

  describe "Required password" do
    test "valid password" do
      changeset = cast("Abc,123456", required: true)
      assert changeset.valid?
      assert changeset.changes[:password]
    end

    test "requires when password is blank" do
      changeset = cast("", required: true)
      refute changeset.valid?
      assert changeset.errors == [password: {"can't be blank", [validation: :required]}]
    end

    test "requires when password is nil" do
      changeset = cast(nil, required: true)
      refute changeset.valid?
      assert changeset.errors == [password: {"can't be blank", [validation: :required]}]
    end
  end

  describe "Validating custom regexp" do
    test "valid password with string regexp" do
      regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&,])(?=.{8,})"

      changeset = cast("Ab,11111", regexp: regexp)
      assert changeset.valid?
      assert changeset.changes[:password]
    end

    test "valid password with sigil regexp" do
      regexp = ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&,])(?=.{8,})/

      changeset = cast("Ab,11111", regexp: regexp)
      assert changeset.valid?
      assert changeset.changes[:password]
    end

    test "invalid password" do
      regexp = ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&,])(?=.{8,})/

      changeset = cast("1111", regexp: regexp)
      refute changeset.valid?
      assert changeset.errors == [password: {"has invalid format", [validation: :format]}]
    end
  end

  defp cast(password, opts \\ []) do
    %User{}
    |> cast(%{password: password}, [])
    |> cast_password(:password, opts)
  end
end
