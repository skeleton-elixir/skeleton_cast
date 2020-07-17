defmodule Skeleton.Cast.VideoUrlTest do
  use Skeleton.Cast.TestCase
  alias Skeleton.App.User
  import Skeleton.Cast.VideoUrl

  describe "Validating youtube url" do
    test "valid video url" do
      [
        "http://www.youtube.com/watch?v=abcdefghij",
        "https://www.youtube.com/watch?v=DFYRQ_zQ-gk&feature=featured",
        "https://www.youtube.com/watch?v=DFYRQ_zQ-gk",
        "http://www.youtube.com/watch?v=DFYRQ_zQ-gk",
        "https://youtube.com/watch?v=DFYRQ_zQ-gk",
        "http://youtube.com/watch?v=DFYRQ_zQ-gk",
        "https://m.youtube.com/watch?v=DFYRQ_zQ-gk",
        "http://m.youtube.com/watch?v=DFYRQ_zQ-gk",
        "https://www.youtube.com/v/DFYRQ_zQ-gk?fs=1&hl=en_US",
        "http://www.youtube.com/v/DFYRQ_zQ-gk?fs=1&hl=en_US",
        "https://www.youtube.com/embed/DFYRQ_zQ-gk?autoplay=1",
        "https://www.youtube.com/embed/DFYRQ_zQ-gk",
        "http://www.youtube.com/embed/DFYRQ_zQ-gk",
        "https://youtube.com/embed/DFYRQ_zQ-gk",
        "http://youtube.com/embed/DFYRQ_zQ-gk",
        "https://youtu.be/DFYRQ_zQ-gk?t=120",
        "https://youtu.be/DFYRQ_zQ-gk",
        "http://youtu.be/DFYRQ_zQ-gk"
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
        "//www.youtube.com/watch?v=DFYRQ_zQ-gk",
        "www.youtube.com/watch?v=DFYRQ_zQ-gk",
        "//youtube.com/watch?v=DFYRQ_zQ-gk",
        "youtube.com/watch?v=DFYRQ_zQ-gk",
        "//m.youtube.com/watch?v=DFYRQ_zQ-gk",
        "m.youtube.com/watch?v=DFYRQ_zQ-gk",
        "//www.youtube.com/v/DFYRQ_zQ-gk?fs=1&hl=en_US",
        "www.youtube.com/v/DFYRQ_zQ-gk?fs=1&hl=en_US",
        "youtube.com/v/DFYRQ_zQ-gk?fs=1&hl=en_US",
        "//www.youtube.com/embed/DFYRQ_zQ-gk",
        "www.youtube.com/embed/DFYRQ_zQ-gk",
        "//youtube.com/embed/DFYRQ_zQ-gk",
        "youtube.com/embed/DFYRQ_zQ-gk",
        "//youtu.be/DFYRQ_zQ-gk",
        "youtu.be/DFYRQ_zQ-gk",
        "https://vimeo.com/62092214",
        "http://vimeo.com/62092214",
        "https://www.vimeo.com/62092214",
      ]
      |> Enum.each(fn video_url ->
        changeset = cast(video_url, [:youtube])
        refute changeset.valid?
        assert changeset.errors == [video_url: {"has invalid format", [validation: :format]}]
      end)
    end
  end

  describe "Validating vimeo url" do
    test "valid video url" do
      [
        "https://vimeo.com/62092214",
        "http://vimeo.com/62092214",
        "https://www.vimeo.com/62092214"
      ]
      |> Enum.each(fn video_url ->
        changeset = cast(video_url, [:vimeo])
        assert changeset.valid?
        assert changeset.changes[:video_url]
      end)
    end

    test "invalid video url" do
      [
        "//vimeo.com/62092214",
        "http://vimeo.com/ddd62092214",
        "https://www.vimeo.com/a62092214ddd"
      ]
      |> Enum.each(fn video_url ->
        changeset = cast(video_url, [:vimeo])
        refute changeset.valid?
        assert changeset.errors == [video_url: {"has invalid format", [validation: :format]}]
      end)
    end
  end

  describe "Requiring video url" do
    test "valid url" do
      changeset = cast("http://youtu.be/DFYRQ_zQ-gk", required: true, sources: [:youtube])
      assert changeset.valid?
      assert changeset.changes[:video_url]
    end

    test "requires when url is blank" do
      changeset =
        %User{}
        |> cast(%{video_url: ""}, [])
        |> cast_video_url(:video_url, required: true, sources: [:youtube])

      refute changeset.valid?
      assert changeset.errors == [video_url: {"can't be blank", [validation: :required]}]
    end

    test "requires when url is nil" do
      changeset =
        %User{}
        |> cast(%{video_url: nil}, [])
        |> cast_video_url(:video_url, required: true, sources: [:youtube])

      refute changeset.valid?
      assert changeset.errors == [video_url: {"can't be blank", [validation: :required]}]
    end
  end

  defp cast(video_url, sources) do
    %User{}
    |> cast(%{video_url: video_url}, [])
    |> cast_video_url(:video_url, sources: sources)
  end
end
