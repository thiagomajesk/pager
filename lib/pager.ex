defmodule Pager do
  defmacro __using__(opts \\ []) do
    quote do
      @doc """
      Returns a `%Pager.Page{}` struct with pagination data.
      Calls the underlyning `#{__MODULE__}.all/2` function.

      Options available are:

      - `:page_size`
      - `:page_number`
      - `:padding`
      - `:prefix`
      """
      def paginate(queryable, opts \\ []) do
        global_opts = Pager.Options.normalize(unquote(opts))
        local_opts = Pager.Options.normalize(opts)

        opts = Keyword.merge(global_opts, local_opts)

        Pager.paginate(queryable, __MODULE__, opts)
      end
    end
  end

  def paginate(query, repo, opts) do
    Pager.Paginator.paginate(query, repo, opts)
  end
end
