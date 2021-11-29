defmodule Pager.HTML.Helpers do
  @moduledoc false

  def page_link(%Plug.Conn{} = conn, page) do
    cond do
      :active in page.states -> page.text
      :disabled in page.states -> page.text
      page.type == :ellipsis -> page.text
      true -> build_link(conn, page)
    end
  end

  def page_class(%{type: type, states: states}) do
    String.trim("#{type} #{Enum.join(states, " ")}")
  end

  defp build_link(%Plug.Conn{request_path: path}, %{text: text, number: number}) do
    params = Plug.Conn.Query.encode(%{"page" => number})
    Phoenix.HTML.Link.link(text, to: "?#{params}")
  end
end
