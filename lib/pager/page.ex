defmodule Pager.Page do
  @moduledoc false

  @type t :: __MODULE__

  @derive {Inspect, except: [:__blueprint__]}

  defstruct [
    :__blueprint__,
    :current_page,
    :page_size,
    :total_pages,
    :total_items,
    :next_page,
    :prev_page,
    :first_page?,
    :last_page?,
    :out_of_range?,
    :padding,
    :items
  ]
end

defimpl Enumerable, for: Pager.Page do
  def count(%Pager.Page{items: items}), do: Enumerable.count(items)
  def member?(%Pager.Page{items: items}, element), do: Enumerable.member?(items, element)
  def slice(%Pager.Page{items: items}), do: Enumerable.slice(items)
  def reduce(%Pager.Page{items: items}, acc, fun), do: Enumerable.reduce(items, acc, fun)
end
