defmodule Pager.HTML do
  @view_module Application.compile_env(:pager, :view_module, Pager.HTML.View)

  def pagination_links(%Plug.Conn{request_path: path}, %Pager.Page{__blueprint__: pages}) do
    Phoenix.View.render_existing(@view_module, "pagination.html", path: path, pages: pages)
  end

  def first_page_link(%Plug.Conn{request_path: path}, %Pager.Page{__blueprint__: pages}) do
    if first_page = Enum.find(pages, &(&1.type == :first)) do
      Pager.HTML.Helpers.page_link(first_page, path)
    end
  end

  def prev_page_link(%Plug.Conn{request_path: path}, %Pager.Page{__blueprint__: pages}) do
    if prev_page = Enum.find(pages, &(&1.type == :prev)) do
      Pager.HTML.Helpers.page_link(prev_page, path)
    end
  end

  def next_page_link(%Plug.Conn{request_path: path}, %Pager.Page{__blueprint__: pages}) do
    if next_page = Enum.find(pages, &(&1.type == :next)) do
      Pager.HTML.Helpers.page_link(next_page, path)
    end
  end

  def last_page_link(%Plug.Conn{request_path: path}, %Pager.Page{__blueprint__: pages}) do
    if last_page = Enum.find(pages, &(&1.type == :last)) do
      Pager.HTML.Helpers.page_link(last_page, path)
    end
  end
end
