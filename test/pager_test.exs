defmodule Pager.PaginatorTest do
  use ExUnit.Case

  import Ecto.Query

  alias Pager.{Repo, User, Page}

  doctest Pager

  setup do
    Repo.delete_all(User)
    Enum.each(fixtures(), &Repo.insert!/1)
  end

  test "should paginate with default opts" do
    page = Repo.paginate(from(u in User))
    assert %Page{items: items, total_items: 14} = page
    assert Enum.count(items) == 10
  end

  test "should paginate with empy params" do
    page = Repo.paginate(from(u in User), %{})
    assert %Page{items: items, total_items: 14} = page
    assert Enum.count(items) == 10
  end

  test "should paginate with alias params" do
    page = Repo.paginate(from(u in User), %{"page" => 2, "size" => 2})
    assert %Page{items: items, total_items: 14, current_page: 2} = page
    assert Enum.count(items) == 2
  end

  test "should paginate with custom opts" do
    page = Repo.paginate(from(u in User), page_number: 2, page_size: 5)
    assert %Page{current_page: 2, page_size: 5, items: items} = page
    assert Enum.count(items) == 5
  end

  test "should paginate with opts as params" do
    page = Repo.paginate(from(u in User), %{"page_number" => "2", "page_size" => "5"})
    assert %Page{current_page: 2, page_size: 5, items: items} = page
    assert Enum.count(items) == 5
  end

  test "should not touch other params other than the relevant opts" do
    page = Repo.paginate(from(u in User), %{"page_number" => "2", "page_size" => "5", "foo" => false})
    assert %Page{current_page: 2, page_size: 5, items: items} = page
    assert Enum.count(items) == 5
  end

  test "paginate/2 accepts options struct" do
    opts = Pager.Options.from(%{"page_number" => "2", "page_size" => "5"})
    page = Repo.paginate(from(u in User), opts)
    assert %Page{current_page: 2, page_size: 5, items: items} = page
    assert Enum.count(items) == 5
  end

  test "page is out of range when page number is greater than what's avaiable to paginate" do
    page = Repo.paginate(from(u in User), %{"page_number" => "3", "page_size" => "14"})
    assert Page.out_of_range?(page)
  end

  test "witout count option should not emit second query" do
    defmodule DummyProvider do
      use Pager.Blueprint

      def explain(page, _opts) do
        [%{type: :infinite, number: page.current_page + 1, text: "More"}]
      end
    end

    page =
      Repo.paginate(from(u in User),
        page_number: 2,
        page_size: 5,
        without_count: true,
        provider: DummyProvider
      )

    assert %Page{current_page: 2, page_size: 5, items: items, total_items: 0} = page
    assert Enum.count(items) == 5
  end

  test "page has the corrent amount of pages" do
    page = Repo.paginate(from(u in User), page_number: 1, page_size: 10)
    assert Pager.Page.total_pages(page) == 2
  end

  defp fixtures do
    [
      %User{name: "Foo"},
      %User{name: "Bar"},
      %User{name: "Baz"},
      %User{name: "Qux"},
      %User{name: "Quux"},
      %User{name: "Quuz"},
      %User{name: "Corge"},
      %User{name: "Grault"},
      %User{name: "Garply"},
      %User{name: "Waldo"},
      %User{name: "Fred"},
      %User{name: "Plugh"},
      %User{name: "Xyzzy"},
      %User{name: "Thud"}
    ]
  end
end
