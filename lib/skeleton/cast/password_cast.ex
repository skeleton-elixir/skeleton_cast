defmodule Skeleton.Cast.Password do
  import Ecto.Changeset

  @password_regexp "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&,-])(?=.{8,})"

  def cast_password(changeset, field, opts \\ []) do
    changeset
    |> cast(changeset.params, [field])
    |> validate_required_field(field, opts)
    |> validate_password(field, opts)
  end

  defp validate_required_field(changeset, field, opts) do
    if opts[:required] do
      validate_required(changeset, [field])
    else
      changeset
    end
  end

  defp validate_password(changeset, field, opts) do
    if changeset.errors[field] do
      changeset
    else
      regexp = build_regexp(opts)

      validate_format(changeset, field, regexp)
    end
  end

  defp build_regexp(opts), do: opts |> Enum.into(%{}) |> do_build_regexp()

  defp do_build_regexp(%{regexp: r}) when is_binary(r), do: Regex.compile!(r)
  defp do_build_regexp(%{regexp: r}), do: r
  defp do_build_regexp(opts) do
    regexp_list = []
    regexp_list = regexp_list ++ if opts[:uppercase], do: ["(?=.*[A-Z])"], else: []
    regexp_list = regexp_list ++ if opts[:downcase], do: ["(?=.*[a-z])"], else: []
    regexp_list = regexp_list ++ if opts[:number], do: ["(?=.*[0-9])"], else: []
    regexp_list = regexp_list ++ if opts[:character], do: ["(?=.*[@$!%*?&,-])"], else: []
    regexp_list = regexp_list ++ if size = opts[:size], do: ["(?=.{#{size},})"], else: []
    regexp_list = regexp_list ++ if regexp_list == [], do: [@password_regexp], else: regexp_list

    regexp_list |> Enum.join("") |> Regex.compile!()
  end
end
