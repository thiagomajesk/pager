defmodule Pager.HTML do
  @view_module Application.compile_env(:pager, :view_module, Pager.HTML.View)

  def pagination_links(%Plug.Conn{request_path: path}, %Pager.Page{__blueprint__: pages}) do
    Phoenix.View.render_existing(@view_module, "pagination.html", path: path, pages: pages)
  end
end
