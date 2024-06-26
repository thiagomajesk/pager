defmodule Pager.HTMLTest do
  use ExUnit.Case
  use Plug.Test

  test "page_class/1 renders proper page class based of the page metadata" do
    assert Pager.HTML.Helpers.page_class(%{type: :page, states: [:foo, :bar, :baz]}) ==
             "page foo bar baz"
  end

  setup do
    [conn: conn(:get, "/foo")]
  end

  describe "page_link/3" do
    test "renders proper page link based of page metadata", %{conn: conn} do
      page = %{type: :page, text: "2", states: [], number: 2}

      assert Pager.HTML.Helpers.page_link(conn, page) ==
               Phoenix.HTML.Link.link("2", to: "/foo?page=2")
    end

    test "ellipsis should have empty links", %{conn: conn} do
      page = %{type: :ellipsis, text: "...", states: [], number: nil}

      assert Pager.HTML.Helpers.page_link(conn, page) ==
               Phoenix.HTML.Tag.content_tag(:span, "...")
    end

    test "active pages should have empty links", %{conn: conn} do
      page = %{type: :page, text: "2", states: [:active], number: 2}

      assert Pager.HTML.Helpers.page_link(conn, page) ==
               Phoenix.HTML.Tag.content_tag(:span, "2")
    end

    test "disabled pages should have empty links", %{conn: conn} do
      page = %{type: :page, text: "2", states: [:disabled], number: 2}

      assert Pager.HTML.Helpers.page_link(conn, page) ==
               Phoenix.HTML.Tag.content_tag(:span, "2")
    end

    test "renders prev link when page exists", %{conn: conn} do
      blueprint = [%{type: :prev, text: "Previous", states: [], number: 1}]
      page = %Pager.Page{__blueprint__: blueprint}

      assert Pager.HTML.prev_page_link!(conn, page) ==
               Phoenix.HTML.Link.link("Previous", to: "/foo?page=1")
    end

    test "using prev_page_link! without blueprint raises", %{conn: conn} do
      assert_raise RuntimeError, "No prev page blueprint found in []", fn ->
        page = %Pager.Page{__blueprint__: []}
        Pager.HTML.prev_page_link!(conn, page)
      end
    end

    test "using prev_page_link without blueprint does not raise", %{conn: conn} do
      page = %Pager.Page{__blueprint__: [], current_page: 2}

      assert Pager.HTML.prev_page_link(conn, page) ==
               Phoenix.HTML.Link.link("‹ Prev", to: "/foo?page=1")
    end

    test "renders first link when page exists", %{conn: conn} do
      blueprint = [%{type: :first, text: "First", states: [], number: 1}]
      page = %Pager.Page{__blueprint__: blueprint}

      assert Pager.HTML.first_page_link(conn, page) ==
               Phoenix.HTML.Link.link("First", to: "/foo?page=1")
    end

    test "renders next link when page exists", %{conn: conn} do
      blueprint = [%{type: :next, text: "Next", states: [], number: 2}]
      page = %Pager.Page{__blueprint__: blueprint}

      assert Pager.HTML.next_page_link!(conn, page) ==
               Phoenix.HTML.Link.link("Next", to: "/foo?page=2")
    end

    test "using next_page_link! without blueprint raises", %{conn: conn} do
      assert_raise RuntimeError, "No next page blueprint found in []", fn ->
        page = %Pager.Page{__blueprint__: []}
        Pager.HTML.next_page_link!(conn, page)
      end
    end

    test "using next_page_link without blueprint does not raise", %{conn: conn} do
      page = %Pager.Page{__blueprint__: [], current_page: 1}

      assert Pager.HTML.next_page_link(conn, page) ==
               Phoenix.HTML.Link.link("Next ›", to: "/foo?page=2")
    end

    test "renders last link when page exists", %{conn: conn} do
      blueprint = [%{type: :last, text: "Last", states: [], number: 2}]
      page = %Pager.Page{__blueprint__: blueprint}

      assert Pager.HTML.last_page_link(conn, page) ==
               Phoenix.HTML.Link.link("Last", to: "/foo?page=2")
    end

    test "pagination params merges with existing path" do
      conn = conn(:get, "?size=10")

      page = %{type: :page, text: "2", states: [], number: 2}

      assert Pager.HTML.Helpers.page_link(conn, page) ==
               Phoenix.HTML.Link.link("2", to: "?page=2&size=10")
    end

    test "renders page link with options", %{conn: conn} do
      page = %{type: :page, text: "2", states: [], number: 2}
      opts = [class: "page-link"]

      assert Pager.HTML.Helpers.page_link(conn, page, opts) ==
               Phoenix.HTML.Link.link("2", Keyword.put(opts, :to, "/foo?page=2"))
    end
  end

  describe "page_link/4" do
    test "renders page link with text block", %{conn: conn} do
      page = %{type: :page, text: "2", states: [], number: 2}

      assert Pager.HTML.Helpers.page_link(conn, page, [], do: "TEXT") ==
               Phoenix.HTML.Link.link("TEXT", to: "/foo?page=2")
    end
  end
end
