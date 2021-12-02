defmodule Pager.Page do
  @moduledoc false

  alias __MODULE__

  @type t :: __MODULE__

  @derive {Inspect, except: [:__blueprint__]}

  defstruct [
    :items,
    :padding,
    :page_size,
    :total_items,
    :current_page,
    :__blueprint__
  ]

  def total_items(%Page{total_items: total_items}) do
    total_items || raise "This page was gererated using the `:without_count` option"
  end

  def total_pages(%Page{} = page) do
    total_pages = total_items(page) / page.page_size
    max(1, Float.ceil(total_pages) |> trunc())
  end

  def first_page(%Page{}), do: 1

  def last_page(%Page{} = page), do: total_pages(page)

  def next_page!(%Page{} = page), do: min(last_page(page), page.current_page + 1)

  def next_page(%Page{} = page), do: page.current_page + 1

  def prev_page(%Page{} = page), do: page.current_page - 1

  def prev_page!(%Page{} = page), do: max(first_page(page), page.current_page - 1)

  def first_page?(%Page{} = page), do: page.current_page == first_page(page)

  def last_page?(%Page{} = page), do: page.current_page == last_page(page)

  # We could always check the first and last pages but we don't want to
  # raise for cases where the total number is absent. So we do our best to
  # identify out of range pages by looking if items are present first.
  def out_of_range?(%Page{current_page: current_page} = page) do
    page.items == [] || current_page < first_page(page) || current_page > last_page(page)
  end
end

defimpl Enumerable, for: Pager.Page do
  def count(%Pager.Page{items: items}), do: Enumerable.count(items)
  def member?(%Pager.Page{items: items}, element), do: Enumerable.member?(items, element)
  def slice(%Pager.Page{items: items}), do: Enumerable.slice(items)
  def reduce(%Pager.Page{items: items}, acc, fun), do: Enumerable.reduce(items, acc, fun)
end
