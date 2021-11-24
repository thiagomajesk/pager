defmodule Pager.HTMLTest do
  use ExUnit.Case

  describe "default provider's template" do
    test "renders proper page class based of the page metadata" do
      assert Pager.HTML.View.page_class(%{type: :page, states: [:foo, :bar, :baz]}) ==
               "page foo bar baz"
    end

    test "renders proper page link based of page metadata" do
      page = %{type: :page, text: "2", states: [], number: 2}
      assert Pager.HTML.View.page_link(page, "/") == Phoenix.HTML.Link.link("2", to: "/?page=2")
    end

    test "ellipsis should not have links" do
      page = %{type: :ellipsis, text: "...", states: [], number: nil}
      assert Pager.HTML.View.page_link(page, "/") == "..."
    end

    test "active pages should not have links" do
      page = %{type: :page, text: "2", states: [:active], number: 2}
      assert Pager.HTML.View.page_link(page, "/") == "2"
    end

    test "disabled pages should not have links" do
      page = %{type: :page, text: "2", states: [:disabled], number: 2}
      assert Pager.HTML.View.page_link(page, "/") == "2"
    end
  end
end
