defmodule Skeleton.Cast.VideoUrl do
  import Ecto.Changeset

  @videos_regexp %{
    youtube:
      ~S"^(https?:\/\/)((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$",
    vimeo:
      ~S"(http|https)?:\/\/(www\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|)(\d+)(?:|\/\?)"
  }

  def cast_video_url(changeset, field, opts \\ []) do
    changeset
    |> cast(changeset.params, [field])
    |> validate_required_field(field, opts)
    |> validate_video_urls(field, opts)
  end

  defp validate_required_field(changeset, field, opts) do
    if opts[:required] do
      validate_required(changeset, [field])
    else
      changeset
    end
  end

  defp validate_video_urls(changeset, field, opts) do
    if changeset.errors[field] do
      changeset
    else
      regexp =
        opts[:sources]
        |> Enum.map(&Map.get(@videos_regexp, &1))
        |> Enum.join("|")
        |> Regex.compile!()

      changeset
      |> format_video_url(field)
      |> validate_format(field, regexp)
    end
  end

  defp format_video_url(changeset, field) do
    if video_url = get_field(changeset, field) do
      video_url = video_url |> String.downcase() |> String.trim()
      put_change(changeset, field, video_url)
    else
      changeset
    end
  end
end
