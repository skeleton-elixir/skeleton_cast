defmodule Skeleton.App.User do
  use Skeleton.App, :schema

  @primary_key false
  schema "users" do
    field :name, :string
    field :email, :string
    field :video_url, :string
    field :password, :string
  end
end