defmodule Pager.HTML.Helpers do
  @moduledoc """
  This module contains helper functions that can be used
  if you are using a custom view module to render your pagination HTML.
  """

  @doc """
  Returns the correct page link if the page is in the correct state.
  Pages with `:active`, `:disabled` or with the type `:ellipsis` only render text.
  """
  def page_link(%Plug.Conn{} = conn, page, opts \\ []) do
    cond do
      :active in page.states -> build_span(page, opts)
      :disabled in page.states -> build_span(page, opts)
      page.type == :ellipsis -> build_span(page, opts)
      true -> build_link(page, Keyword.put(opts, :to, build_path(conn, page)))
    end
  end
  
  @doc """
  Same as `page_link/3` but accepts a block to be the page text.
  """
  def page_link(%Plug.Conn{} = conn, page, opts, do: block) when is_list(opts) do
    page_link(conn, Map.put(page, :text, block), opts)
  end

  @doc """
  Returns the page classes based on the type and states present.
  """
  def page_class(%{type: type, states: states}) do
    String.trim("#{type} #{Enum.join(states, " ")}")
  end
  
  defp build_path(conn, %{number: number}) do
    query_string =
      conn
      |> Plug.Conn.fetch_query_params()
      |> Map.get(:query_params)
      |> Map.put("page", number)
      |> Plug.Conn.Query.encode()
      
    "#{conn.request_path}?#{query_string}"
  end
  
  defp build_span(%{text: text}, opts) do
    Phoenix.HTML.Tag.content_tag(:span, text, opts)
  end
  
  defp build_link(%{text: text}, opts) do
    Phoenix.HTML.Link.link(text, opts)
  end
end
