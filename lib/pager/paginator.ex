defmodule Pager.Paginator do
  @moduledoc false

  import Ecto.Query, only: [limit: 2, offset: 2, exclude: 2, select: 2, subquery: 1]

  def paginate(query, repo, %Pager.Options{} = opts) do
    %{
      prefix: prefix,
      padding: padding,
      provider: provider,
      page_size: page_size,
      page_number: page_number,
      without_count: without_count
    } = opts

    query
    |> limit_query(page_number, page_size, padding)
    |> execute_query(repo, prefix)
    |> calculate_total(query, without_count, repo, prefix)
    |> convert_to_page(page_number, page_size, padding)
    |> generate_pagination_blueprint(provider)
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

  defp calculate_total(map, query, halt, repo, prefix) do
    total =
      unless halt do
        query
        |> exclude(:preload)
        |> exclude(:order_by)
        |> subquery()
        |> select(count("*"))
        |> repo.one(prefix: prefix)
        || 0
      end
      
    Map.put(map, :total_items, total)
  end

  defp convert_to_page(%{items: items, total_items: total_items}, page_number, page_size, padding) do
    %Pager.Page{
      items: items,
      total_items: total_items,
      current_page: page_number,
      page_size: page_size,
      padding: padding
    }
  end

  defp generate_pagination_blueprint(page, nil) do
    %{page | __blueprint__: Pager.Blueprint.explain(page)}
  end

  defp generate_pagination_blueprint(page, provider) do
    %{page | __blueprint__: provider.explain(page)}
  end
end
