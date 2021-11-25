defmodule Pager.Providers.Compact do
  @moduledoc false
  use Pager.Blueprint

  def explain(%Pager.Page{} = page, _opts) do
    Enum.concat([[first(page)], [prev(page)], [next(page)], [last(page)]])
  end
end
