defmodule Skeleton.Cast.Password do
  import Ecto.Changeset

  @password_regexp ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})/

  def cast_password(changeset, field, opts \\ []) do
    changeset
    |> cast(changeset.params, [field])
    |> validate_required_field(field, opts)
    |> validate_password(field)
  end

  defp validate_required_field(changeset, field, opts) do
    if opts[:required] do
      validate_required(changeset, [field])
    else
      changeset
    end
  end

  defp validate_password(changeset, field) do
    if changeset.errors[field] do
      changeset
    else
      validate_format(changeset, field, @password_regexp)
    end
  end
end