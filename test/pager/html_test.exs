defmodule Pager.HTMLTest do
  use ExUnit.Case

  import Ecto.Query
  import Pager.HTML

  alias Pager.{Repo, User}

  setup do
    Repo.delete_all(User)
    Enum.each(fixtures(), &Repo.insert!/1)

    page = Repo.paginate(from(u in User))

    [conn: Plug.Test.conn(:get, "/"), page: page]
  end

  describe "default provider" do
    Application.put_env(:pager, :provider, Pager.Providers.Default)

    test "returns properly rendered html", %{conn: conn, page: page} do
      assert Pager.HTML.pagination_links(conn, page) |> Phoenix.HTML.safe_to_string() == nil
    end
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
