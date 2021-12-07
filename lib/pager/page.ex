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

  @doc """
  Returns the total number of items in the database.
  Raises if using the `:without_count` option.
  """
  def total_items(%Page{total_items: total_items}) do
    total_items || raise "This page was gererated using the `:without_count` option"
  end

  @doc """
  Returns the total number of pages available to paginate.
  Relies on `total_items/1` to calculate the number of pages.
  """
  def total_pages(%Page{} = page) do
    total_pages = total_items(page) / page.page_size
    max(1, Float.ceil(total_pages) |> trunc())
  end

  @doc """
  Returns the first page number.
  """
  def first_page(%Page{}), do: 1

  @doc """
  Returns the last page number.
  Relies on `total_pages/1` to calculate the last page number.
  """
  def last_page(%Page{} = page), do: total_pages(page)

  @doc """
  Returns the next page number.
  Relies on `last_page/1` to calculate the next page number.
  The return is guaranteed to be within the bounds of the total number of pages.
  """
  def next_page!(%Page{} = page), do: min(last_page(page), page.current_page + 1)

  @doc """
  Returns the next page number.
  This is the naive version of `next_page!/1`, since it does'nt check for bounds.
  The return is not guaranteed to be within the bounds of the total number of pages.
  """
  def next_page(%Page{} = page), do: page.current_page + 1

  @doc """
  Returns the previous page number.
  This is the naive version of `prev_page!/1`, since it does'nt check for bounds.
  The return is not guaranteed to be within the bounds of the total number of pages.
  """
  def prev_page(%Page{} = page), do: page.current_page - 1

  @doc """
  Returns the previous page number.
  Relies on `first_page/1` to calculate the previous page number.
  The return is guaranteed to be within the bounds of the total number of pages.
  """
  def prev_page!(%Page{} = page), do: max(first_page(page), page.current_page - 1)

  @doc """
  Checks if the current page is the first page.
  """
  def first_page?(%Page{} = page), do: page.current_page == first_page(page)

  @doc """
  Checks if the current page is the last page.
  """
  def last_page?(%Page{} = page), do: page.current_page == last_page(page)

  @doc """
  Check if the current page is within the bounds of the total number of pages.
  This is specially usefull when you are using the `:without_count` option and the naive `next_page/1` and `prev_page/1` functions.
  """
  def out_of_range?(%Page{current_page: current_page} = page) do
    # We could always check the first and last pages but we don't want to
    # raise for cases where the total number is absent. So we do our best to
    # identify out of range pages by looking if items are present first.
    page.items == [] || current_page < first_page(page) || current_page > last_page(page)
  end
end

defimpl Enumerable, for: Pager.Page do
  def count(%Pager.Page{items: items}), do: Enumerable.count(items)
  def member?(%Pager.Page{items: items}, element), do: Enumerable.member?(items, element)
  def slice(%Pager.Page{items: items}), do: Enumerable.slice(items)
  def reduce(%Pager.Page{items: items}, acc, fun), do: Enumerable.reduce(items, acc, fun)
end
