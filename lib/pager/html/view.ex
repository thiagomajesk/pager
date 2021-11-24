defmodule Pager.HTML.View do
  use Phoenix.View,
    root: "lib/pager/html/templates",
    namespace: Pager.HTML

  def page_link(page, path) do
    %{type: type, text: text, states: states, number: number} = page

    cond do
      :active in states -> text
      :disabled in states -> text
      type == :ellipsis -> text
      true -> Phoenix.HTML.Link.link(text, to: "#{path}?page=#{number}")
    end
  end

  def page_class(%{type: type, states: states}) do
    String.trim("#{type} #{Enum.join(states, " ")}")
  end
end
