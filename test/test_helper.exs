defmodule Skeleton.Cast.TestCase do
  use ExUnit.CaseTemplate

  using opts do
    quote do
      use ExUnit.Case, unquote(opts)
      import Ecto.Changeset
    end
  end
end

ExUnit.start()
