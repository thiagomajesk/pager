defmodule Pager.Paginator do
  @moduledoc false

  import Ecto.Query, only: [limit: 2, offset: 2, exclude: 2]

  def paginate(query, page_number, page_size, padding, repo, prefix) do
    query
    |> limit_query(page_number, page_size, padding)
    |> execute_query(repo, prefix)
    |> calculate_total(query, repo, prefix)
    |> convert_to_page(page_number, page_size, padding)
    |> generate_pagination_blueprint()
  end

  defp limit_query(query, page_number, page_size, _padding) do
    offset = max(0, (page_number - 1) * page_size)

    query
    |> limit(^page_size)
    |> offset(^offset)
  end

  defp execute_query(query, repo, prefix) do
    %{items: repo.all(query, prefix: prefix)}
  end

  defp calculate_total(map, query, repo, prefix) do
    total =
      query
      |> exclude(:preload)
      |> exclude(:order_by)
      |> exclude(:select)
      |> repo.aggregate(:count, prefix: prefix)

    Map.put(map, :total_items, total)
  end

  defp convert_to_page(%{items: items, total_items: total_items}, page_number, page_size, padding) do
    total_pages = max(1, div(total_items, page_size))
    next_page = max(page_number + 1, total_pages)
    prev_page = min(page_number - 1, 1)
    first_page? = page_number == 1
    last_page? = page_number == total_pages
    out_of_range? = page_number < 1 || page_number > total_pages

    %Pager.Page{
      items: items,
      total_items: total_items,
      total_pages: total_pages,
      current_page: page_number,
      page_size: page_size,
      padding: padding,
      next_page: next_page,
      prev_page: prev_page,
      first_page?: first_page?,
      last_page?: last_page?,
      out_of_range?: out_of_range?
    }
  end

  defp generate_pagination_blueprint(page) do
    %{page | __blueprint__: Pager.Blueprint.explain(page)}
  end
end
