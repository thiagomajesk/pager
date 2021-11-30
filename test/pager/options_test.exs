defmodule Pager.OptionsTest do
  use ExUnit.Case
  use Plug.Test

  test "merge/2 globals are used when there's no local options" do
    assert %Pager.Options{page_size: 5, page_number: 2, padding: 1} =
             Pager.Options.merge([page_size: 5, page_number: 2, padding: 1], [])
  end

  test "merge/2 raises if nil is passed to an option" do
    assert_raise RuntimeError, "Invalid value for option :page_size. Received nil", fn ->
      Pager.Options.merge([page_size: nil], [])
    end
  end

  test "merge/2 raises if negative number is passed to an option" do
    assert_raise RuntimeError, "Option :page_size cannot be a negative number. Received -1", fn ->
      Pager.Options.merge([page_size: -1], [])
    end
  end

  test "from/1 parse options from map" do
    %Pager.Options{page_size: 5, page_number: 2} =
      Pager.Options.from(%{"page_size" => 5, "page_number" => 2})
  end

  test "from/1 parse options from list" do
    %Pager.Options{page_size: 5, page_number: 2} =
      Pager.Options.from([page_size: 5, page_number: 2])
  end
end
