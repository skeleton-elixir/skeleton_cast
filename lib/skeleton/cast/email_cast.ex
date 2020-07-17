defmodule Skeleton.Cast.Email do
  import Ecto.Changeset

  @email_regexp ~r(^[\w!#$%&'*+\-/=?^`{|}~.]+@[\w!#$%&'*+\-/=?^`{|}~.]+\.[\w!#$%&'*+\-/=?^`{|}~]+$)

  def cast_email(changeset, field, opts \\ []) do
    changeset
    |> cast(changeset.params, [field])
    |> validate_required_field(field, opts)
    |> validate_email(field)
  end

  defp validate_required_field(changeset, field, opts) do
    if opts[:required] do
      validate_required(changeset, [field])
    else
      changeset
    end
  end

  defp validate_email(changeset, field) do
    if changeset.errors[field] do
      changeset
    else
      changeset
      |> format_email(field)
      |> validate_format(field, @email_regexp)
    end
  end

  defp format_email(changeset, field) do
    if email = get_field(changeset, field) do
      email = email |> String.downcase |> String.trim()
      put_change(changeset, field, email)
    else
      changeset
    end
  end
end
