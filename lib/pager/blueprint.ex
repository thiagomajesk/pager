defmodule Pager.Blueprint do
  @provider Application.compile_env(:pager, :provider, Pager.Providers.Default)

  @type item :: %{
          type: atom(),
          text: binary(),
          number: integer(),
          states: [:active | :disabled]
        }

  @callback explain(page :: Pager.Page.t(), opts :: keyword()) :: list(item())

  defdelegate explain(page), to: @provider
  defdelegate explain(page, opts), to: @provider

  defmacro __using__(_opts) do
    quote do
      @behaviour Pager.Blueprint

      @impl true
      def explain(page, opts \\ [])

      def explain(_page, _opts) do
        raise "Blueprint logic not implemented for #{inspect(__MODULE__)}"
      end

      defoverridable explain: 2

      defp page(page, number) do
        %{
          type: :page,
          text: "#{number}",
          number: number,
          states: map_states(active: number == page.current_page)
        }
      end

      defp ellipsis() do
        %{
          type: :ellipsis,
          text: "...",
          number: nil,
          states: []
        }
      end

      defp first(page) do
        %{
          type: :first,
          text: "« First",
          number: 1,
          states: map_states(disabled: page.current_page == 1)
        }
      end

      defp prev(page) do
        %{
          type: :prev,
          text: "‹ Prev",
          number: max(page.current_page - 1, 1),
          states: map_states(disabled: page.current_page == 1)
        }
      end

      defp next(page) do
        %{
          type: :next,
          text: "Next ›",
          number: min(page.current_page + 1, page.total_pages),
          states: map_states(disabled: page.current_page == page.total_pages)
        }
      end

      defp last(page) do
        %{
          type: :last,
          text: "Last »",
          number: page.total_pages,
          states: map_states(disabled: page.current_page == page.total_pages)
        }
      end

      # Converts a keyword with true values to a list of atoms.
      # Eg: [foo: true, bar: true, foobar: false] -> [:foo, :bar]
      defp map_states(states) do
        states
        |> Enum.filter(fn {_key, value} -> value end)
        |> Enum.map(fn {key, _value} -> key end)
      end
    end
  end
end
