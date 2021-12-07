defmodule Pager.HTML.Helpers do
  @moduledoc """
  This module contains helper functions that can be used
  if you are using a custom view module to render your pagination HTML.
  """

  @doc """
  Returns the correct page link if the page is in the correct state.
  Pages with `:active`, `:disabled` or with the type `:ellipsis` only render text.
  """
  def page_link(%Plug.Conn{} = conn, page) do
    cond do
      :active in page.states -> page.text
      :disabled in page.states -> page.text
      page.type == :ellipsis -> page.text
      true -> build_link(conn, page)
    end
  end

  @doc """
  Returns the page classes based on the type and states present.
  """
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
