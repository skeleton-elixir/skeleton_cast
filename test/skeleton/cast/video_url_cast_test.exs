defmodule Skeleton.Cast.VideoUrlTest do
  use Skeleton.Cast.TestCase
  alias Skeleton.App.User
  import Skeleton.Cast.VideoUrl

  describe "Validating youtube url" do
    test "valid video url" do
      [
        "http://www.youtube.com/watch?v=abcdefghij",
      ]
      |> Enum.each(fn video_url ->
        changeset = cast(video_url, [:youtube])
        assert changeset.valid?
        assert changeset.changes[:video_url]
      end)
    end

    test "invalid video url" do
      [
        "httpwww.youtube.com/watch?v=abcdefghij",
      ]
      |> Enum.each(fn video_url ->
        changeset = cast(video_url, [:youtube])
        refute changeset.valid?
        assert changeset.errors == [video_url: {"has invalid format", [validation: :format]}]
      end)
    end
  end

  describe "Requiring video url" do
  end

  defp cast(video_url, sources) do
    %User{}
    |> cast(%{video_url: video_url}, [])
    |> cast_video_url(:video_url, sources: sources)
  end
end
