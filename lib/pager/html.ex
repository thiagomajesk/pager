defmodule Pager.HTML do
  @view_module Application.compile_env(:pager, :view_module, Pager.HTML.View)

  def pagination_links(%Plug.Conn{} = conn, %Pager.Page{__blueprint__: pages}) do
    Phoenix.View.render_existing(@view_module, "pagination.html", conn: conn, pages: pages)
  end

  def first_page_link(%Plug.Conn{} = conn, %Pager.Page{__blueprint__: pages}) do
    if first_page = Enum.find(pages, &(&1.type == :first)) do
      Pager.HTML.Helpers.page_link(conn, first_page)
    end
  end

  def prev_page_link(%Plug.Conn{} = conn, %Pager.Page{} = page) do
    Pager.HTML.Helpers.page_link(conn, %{type: :prev, text: "‹ Prev", number: Pager.Page.prev_page(page), states: []})
  end

  def prev_page_link!(%Plug.Conn{} = conn, %Pager.Page{__blueprint__: pages}) do
    if prev_page = Enum.find(pages, &(&1.type == :prev)) do
      Pager.HTML.Helpers.page_link(conn, prev_page)
    else
      raise "No prev page blueprint found in #{inspect(pages)}"
    end
  end

  def next_page_link(%Plug.Conn{} = conn, %Pager.Page{} = page) do
    Pager.HTML.Helpers.page_link(conn, %{type: :next, text: "Next ›", number: Pager.Page.next_page(page), states: []})
  end

  def next_page_link!(%Plug.Conn{} = conn, %Pager.Page{__blueprint__: pages}) do
    if next_page = Enum.find(pages, &(&1.type == :next)) do
      Pager.HTML.Helpers.page_link(conn, next_page)
    else
      raise "No next page blueprint found in #{inspect(pages)}"
    end
  end

  def last_page_link(%Plug.Conn{} = conn, %Pager.Page{__blueprint__: pages}) do
    if last_page = Enum.find(pages, &(&1.type == :last)) do
      Pager.HTML.Helpers.page_link(conn, last_page)
    end
  end
end
