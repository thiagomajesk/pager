defmodule Pager.HTML.View do
  use Phoenix.View,
    root: "lib/pager/html/templates",
    namespace: Pager.HTML

  def link_or_text(%{active?: true, text: text}, _path), do: text
  def link_or_text(%{disabled?: true, text: text}, _path), do: text
  def link_or_text(%{type: type, text: text}, _path) when type not in [:page], do: text

  def link_or_text(%{type: :page} = page, path) do
    Phoenix.HTML.Link.link(page.text, to: "#{path}?page=#{page.number}")
  end

  def page_classes(%{type: type, states: states}) do
    String.trim("#{type} #{Enum.join(states, "")}")
  end
end
