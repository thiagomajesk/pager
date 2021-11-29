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

  defp build_link(%Plug.Conn{} = conn, %{text: text, number: number}) do
    query_string =
      conn
      |> Plug.Conn.fetch_query_params()
      |> Map.get(:query_params)
      |> Map.put("page", number)
      |> Plug.Conn.Query.encode()

    Phoenix.HTML.Link.link(text, to: "#{conn.request_path}?#{query_string}")
  end
end
