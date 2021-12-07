defmodule Pager do
  @moduledoc """
  Provides the `Pager.paginate/2` function that can be used to paginate records.
  You should `use` this module in your Repo to make the `paginate/2` fuction available.
  """

  defmacro __using__(opts \\ []) do
    quote do
      @doc """
      Returns a `%Pager.Page{}` struct with pagination data.
      Calls the underlyning `#{__MODULE__}.all/2` function.
      Check the module `Pager.Options` for all available options.
      """
      def paginate(query, opts \\ [])

      def paginate(query, %Pager.Options{} = opts) do
        paginate(query, Map.from_struct(opts))
      end

      def paginate(query, opts) do
        opts = Pager.Options.merge(unquote(opts), opts)
        Pager.paginate(query, __MODULE__, opts)
      end
    end
  end

  def paginate(query, repo, %Pager.Options{} = opts) do
    Pager.Paginator.paginate(query, repo, opts)
  end
end
