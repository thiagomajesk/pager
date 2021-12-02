defmodule Pager.PageTest do
  use ExUnit.Case
  use Plug.Test

  alias Pager.Page

  test "total_items/1" do
    assert Page.total_items(%Page{current_page: 1, total_items: 15, page_size: 5}) == 15
  end

  test "total_pages/1" do
    assert Page.total_pages(%Page{current_page: 1, total_items: 15, page_size: 5}) == 3
  end

  test "first_page/1" do
    assert Page.first_page(%Page{current_page: 1, total_items: 15, page_size: 5}) == 1
  end

  test "last_page/1" do
    assert Page.last_page(%Page{current_page: 3, total_items: 15, page_size: 5}) == 3
  end

  test "first_page?/1" do
    assert Page.first_page?(%Page{current_page: 1, total_items: 15, page_size: 5}) == true
    assert Page.first_page?(%Page{current_page: 3, total_items: 15, page_size: 5}) == false
  end

  test "last_page?/1" do
    assert Page.last_page?(%Page{current_page: 3, total_items: 15, page_size: 5}) == true
    assert Page.last_page?(%Page{current_page: 1, total_items: 15, page_size: 5}) == false
  end

  test "out_of_range?/1" do
    assert Page.out_of_range?(%Page{current_page: 1, total_items: 15, page_size: 5, items: []}) == true
    assert Page.out_of_range?(%Page{current_page: 1, total_items: 15, page_size: 5, items: []}) == true

    assert Page.out_of_range?(%Page{current_page: 1, total_items: 15, page_size: 5, items: nil}) == false
    assert Page.out_of_range?(%Page{current_page: 4, total_items: 15, page_size: 5, items: nil}) == true

    assert Page.out_of_range?(%Page{current_page: 1, total_items: 15, page_size: 5, items: [%{}]}) == false
    assert Page.out_of_range?(%Page{current_page: 4, total_items: 15, page_size: 5, items: [%{}]}) == true
  end

  test "next_page/1 returns the current page + 1" do
    assert Page.next_page(%Page{current_page: 3, total_items: 15, page_size: 5}) == 4
  end

  test "next_page!/1 caps the next page to the maximum available pages" do
    assert Page.next_page!(%Page{current_page: 3, total_items: 15, page_size: 5}) == 3
  end

  test "prev_page/1 returns the current page -1" do
    assert Page.prev_page(%Page{current_page: 1, total_items: 15, page_size: 5}) == 0
  end

  test "prev_page!/1 caps the prev page to the first page " do
    assert Page.prev_page!(%Page{current_page: 1, total_items: 15, page_size: 5}) == 1
  end
end
