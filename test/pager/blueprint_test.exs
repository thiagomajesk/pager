defmodule Pager.BlueprintTest do
  use ExUnit.Case

  describe "blueprint protocol" do
    test "should raise when no custom implementation is present" do
      defmodule DummyImplementation do
        use Pager.Blueprint
      end

      assert_raise RuntimeError, ~r/Blueprint logic not implemented for \w/, fn ->
        DummyImplementation.explain(%Pager.Page{})
      end
    end
  end

  describe "default provider" do
    test "disables the first page when current page it's already the first one" do
      blueprint = Pager.Providers.Default.explain(%Pager.Page{current_page: 1, total_items: 50, page_size: 10})
      assert [%{states: [:disabled]}] = Enum.filter(blueprint, &(&1.type == :first))
    end

    test "enables the first page when current page it's not the first one" do
      blueprint = Pager.Providers.Default.explain(%Pager.Page{current_page: 2, total_items: 50, page_size: 10})
      assert [%{states: []}] = Enum.filter(blueprint, &(&1.type == :first))
    end

    test "disables the prev page when it's not relevant" do
      blueprint = Pager.Providers.Default.explain(%Pager.Page{current_page: 1, total_items: 50, page_size: 10})
      assert [%{states: [:disabled]}] = Enum.filter(blueprint, &(&1.type == :prev))
    end

    test "enables the prev page when it's relevant" do
      blueprint = Pager.Providers.Default.explain(%Pager.Page{current_page: 2, total_items: 50, page_size: 10})
      assert [%{states: []}] = Enum.filter(blueprint, &(&1.type == :prev))
    end

    test "disables the last page when current page it's already the last one" do
      blueprint = Pager.Providers.Default.explain(%Pager.Page{current_page: 5, total_items: 50, page_size: 10})
      assert [%{states: [:disabled]}] = Enum.filter(blueprint, &(&1.type == :last))
    end

    test "enables the last page when current page it's not the last one" do
      blueprint = Pager.Providers.Default.explain(%Pager.Page{current_page: 4, total_items: 50, page_size: 10})
      assert [%{states: []}] = Enum.filter(blueprint, &(&1.type == :last))
    end

    test "disables the next page when it's not relevant" do
      blueprint = Pager.Providers.Default.explain(%Pager.Page{current_page: 5, total_items: 50, page_size: 10})
      assert [%{states: [:disabled]}] = Enum.filter(blueprint, &(&1.type == :next))
    end

    test "enables the next page when it's relevant" do
      blueprint = Pager.Providers.Default.explain(%Pager.Page{current_page: 4, total_items: 50, page_size: 10})
      assert [%{states: []}] = Enum.filter(blueprint, &(&1.type == :next))
    end

    test "show outer window to the right if inner window is long enough" do
      blueprint =
        Pager.Blueprint.explain(%Pager.Page{current_page: 1, total_items: 50, page_size: 10},
          inner_window: 1,
          outer_window: 1
        )

      assert [
               %{type: :first},
               %{type: :prev},
               _,
               _,
               %{type: :ellipsis},
               _,
               %{type: :next},
               %{type: :last}
             ] = blueprint
    end

    test "show outer window to the left if inner window is long enough" do
      blueprint =
        Pager.Blueprint.explain(%Pager.Page{current_page: 5, total_items: 50, page_size: 10},
          inner_window: 1,
          outer_window: 1
        )

      assert [
               %{type: :first},
               %{type: :prev},
               _,
               %{type: :ellipsis},
               _,
               _,
               %{type: :next},
               %{type: :last}
             ] = blueprint
    end

    test "don't show outer window if inner window is too short" do
      blueprint =
        Pager.Blueprint.explain(%Pager.Page{current_page: 1, total_items: 50, page_size: 10}, outer_window: 2)

      assert [
               _,
               _,
               %{type: page},
               %{type: page},
               %{type: page},
               %{type: page},
               %{type: page},
               _,
               _
             ] = blueprint
    end

    test "when outer window is disabled, don't show ellipsis" do
      blueprint = Pager.Blueprint.explain(%Pager.Page{current_page: 1, total_items: 50, page_size: 10})

      assert [
               _,
               _,
               %{type: page},
               %{type: page},
               %{type: page},
               %{type: page},
               %{type: page},
               _,
               _
             ] = blueprint
    end
  end

  describe "compact provider" do
    test "disables the first page when current page it's already the first one" do
      blueprint = Pager.Providers.Compact.explain(%Pager.Page{current_page: 1, total_items: 50, page_size: 10})
      assert [%{states: [:disabled]}] = Enum.filter(blueprint, &(&1.type == :first))
    end

    test "enables the first page when current page it's not the first one" do
      blueprint = Pager.Providers.Compact.explain(%Pager.Page{current_page: 2, total_items: 50, page_size: 10})
      assert [%{states: []}] = Enum.filter(blueprint, &(&1.type == :first))
    end

    test "disables the prev page when it's not relevant" do
      blueprint = Pager.Providers.Compact.explain(%Pager.Page{current_page: 1, total_items: 50, page_size: 10})
      assert [%{states: [:disabled]}] = Enum.filter(blueprint, &(&1.type == :prev))
    end

    test "enables the prev page when it's relevant" do
      blueprint = Pager.Providers.Compact.explain(%Pager.Page{current_page: 2, total_items: 50, page_size: 10})
      assert [%{states: []}] = Enum.filter(blueprint, &(&1.type == :prev))
    end

    test "disables the last page when current page it's already the last one" do
      blueprint = Pager.Providers.Compact.explain(%Pager.Page{current_page: 5, total_items: 50, page_size: 10})
      assert [%{states: [:disabled]}] = Enum.filter(blueprint, &(&1.type == :last))
    end

    test "enables the last page when current page it's not the last one" do
      blueprint = Pager.Providers.Compact.explain(%Pager.Page{current_page: 4, total_items: 50, page_size: 10})
      assert [%{states: []}] = Enum.filter(blueprint, &(&1.type == :last))
    end

    test "disables the next page when it's not relevant" do
      blueprint = Pager.Providers.Compact.explain(%Pager.Page{current_page: 5, total_items: 50, page_size: 10})
      assert [%{states: [:disabled]}] = Enum.filter(blueprint, &(&1.type == :next))
    end

    test "enables the next page when it's relevant" do
      blueprint = Pager.Blueprint.explain(%Pager.Page{current_page: 4, total_items: 50, page_size: 10})
      assert [%{states: []}] = Enum.filter(blueprint, &(&1.type == :next))
    end
  end
end
