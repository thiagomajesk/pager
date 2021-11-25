defmodule Pager.HTMLTest do
  use ExUnit.Case

  describe "view helpers" do
    test "renders proper page class based of the page metadata" do
      assert Pager.HTML.Helpers.page_class(%{type: :page, states: [:foo, :bar, :baz]}) ==
               "page foo bar baz"
    end

    test "renders proper page link based of page metadata" do
      page = %{type: :page, text: "2", states: [], number: 2}

      assert Pager.HTML.Helpers.page_link(page, "/") ==
               Phoenix.HTML.Link.link("2", to: "/?page=2")
    end

    test "ellipsis should not have links" do
      page = %{type: :ellipsis, text: "...", states: [], number: nil}
      assert Pager.HTML.Helpers.page_link(page, "/") == "..."
    end

    test "active pages should not have links" do
      page = %{type: :page, text: "2", states: [:active], number: 2}
      assert Pager.HTML.Helpers.page_link(page, "/") == "2"
    end

    test "disabled pages should not have links" do
      page = %{type: :page, text: "2", states: [:disabled], number: 2}
      assert Pager.HTML.Helpers.page_link(page, "/") == "2"
    end

    test "renders prev link when page exists" do
      blueprint = [%{type: :prev, text: "Previous", states: [], number: 1}]
      page = %Pager.Page{__blueprint__: blueprint}

      assert Pager.HTML.prev_page_link(%Plug.Conn{request_path: "/"}, page) ==
               Phoenix.HTML.Link.link("Previous", to: "/?page=1")
    end

    test "renders first link when page exists" do
      blueprint = [%{type: :first, text: "First", states: [], number: 1}]
      page = %Pager.Page{__blueprint__: blueprint}

      assert Pager.HTML.first_page_link(%Plug.Conn{request_path: "/"}, page) ==
               Phoenix.HTML.Link.link("First", to: "/?page=1")
    end

    test "renders next link when page exists" do
      blueprint = [%{type: :next, text: "Next", states: [], number: 2}]
      page = %Pager.Page{__blueprint__: blueprint}

      assert Pager.HTML.next_page_link(%Plug.Conn{request_path: "/"}, page) ==
               Phoenix.HTML.Link.link("Next", to: "/?page=2")
    end

    test "renders last link when page exists" do
      blueprint = [%{type: :last, text: "Last", states: [], number: 2}]
      page = %Pager.Page{__blueprint__: blueprint}

      assert Pager.HTML.last_page_link(%Plug.Conn{request_path: "/"}, page) ==
               Phoenix.HTML.Link.link("Last", to: "/?page=2")
    end
  end
end
