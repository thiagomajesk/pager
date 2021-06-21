defmodule Pager.Providers.Default do
  @moduledoc false
  use Pager.Blueprint

  def explain(%Pager.Page{} = page, opts) do
    %{current_page: current_page, total_pages: total_pages} = page

    inner_window = opts[:inner_window] || Application.get_env(:pager, :inner_window, 4)
    outer_window = opts[:outer_window] || Application.get_env(:pager, :outer_window, 0)

    inner_window_start = max(current_page - inner_window, 1)
    inner_window_end = min(current_page + inner_window, total_pages)
    inner_window_range = inner_window_start..inner_window_end

    inner_window =
      inner_window_range
      |> Enum.to_list()
      |> Enum.map(&page(page, &1))

    outer_window_left_start = 1
    outer_window_left_end = 1 + outer_window - 1
    outer_window_left_range = outer_window_left_start..outer_window_left_end//1

    outer_window_left =
      if outer_window > 0 and Range.disjoint?(inner_window_range, outer_window_left_range) do
        outer_window_left_pages =
          outer_window_left_range
          |> Enum.to_list()
          |> Enum.map(&page(page, &1))

        Enum.concat([outer_window_left_pages, [ellipsis()]])
      end

    outer_window_right_start = total_pages - outer_window
    outer_window_right_end = total_pages - 1
    outer_window_right_range = outer_window_right_start..outer_window_right_end//1

    outer_window_right =
      if outer_window > 0 and Range.disjoint?(inner_window_range, outer_window_right_range) do
        outer_window_right_pages =
          outer_window_right_range
          |> Enum.to_list()
          |> Enum.map(&page(page, &1))

        Enum.concat([ellipsis()], outer_window_right_pages)
      end

    Enum.concat([
      [first(page)],
      [prev(page)],
      outer_window_left || [],
      inner_window,
      outer_window_right || [],
      [next(page)],
      [last(page)]
    ])
  end
end
