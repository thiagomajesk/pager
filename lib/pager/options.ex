defmodule Pager.Options do
  @moduledoc """
  Define pagination options that can be used with `Pager.paginate/2`.

  ## Options

  - `:page_number` - The current page number, defaults to `1`.
  - `:page_size` - The number of items per page, defaults to `10`.
  - `:provider` - The blueprint provider, defaults to `Pager.Providers.Default`.
  - `:prefix` - The prefix that will be used in the pagination query.
  - `:without_count` - Whether to skip the count query, defaults to `false`.
  """

  defstruct page_number: 1,
            page_size: 10,
            padding: 0,
            provider: nil,
            prefix: nil,
            without_count: false

  @doc """
  Merges the given pagination options and returns a `%Pager.Options{}` struct.
  Options will first be normalized, validated and then merged together.
  """
  def merge(opts1, opts2) do
    opts1 = normalize(opts1)
    opts2 = normalize(opts2)
    merged = Keyword.merge(opts1, opts2)
    struct(__MODULE__, merged)
  end

  @doc """
  Converts the given option to a `%Pager.Options{}` struct.
  This could be very useful if you need to cast the request params, for example.
  """
  def from(opts) do
    opts = normalize(opts)
    struct(__MODULE__, opts)
  end

  defp normalize(opts) do
    (opts || [])
    |> Enum.to_list()
    |> parse_values()
    |> Enum.reject(&is_nil/1)
  end

  # Accepts both standard keys and aliases.
  # We should also accept keys as strings.
  defp parse_values(opts) do
    Enum.map(opts, fn
      {k, v} when k in [:page_number, :page, :p, "page_number", "page", "p"] ->
        {:page_number, parse_option(maybe_atomize(k), v)}

      {k, v} when k in [:page_size, :size, :s, "page_size", "size", "s"] ->
        {:page_size, parse_option(maybe_atomize(k), v)}

      {k, v} when k in [:padding, :offset, :skip, "padding", "offset", "skip"] ->
        {:padding, parse_option(maybe_atomize(k), v)}
        
      {k, v} when k in [:provider, :prefix, :without_count] ->
        {k, v}

      _kv ->
        nil
    end)
  end

  defp parse_option(key, value) when is_binary(value),
    do: parse_option(key, String.to_integer(value))

  defp parse_option(key, value) when is_integer(value) and value < 0,
    do: raise("Option #{inspect(key)} cannot be a negative number. Received #{inspect(value)}")

  defp parse_option(_key, value) when is_integer(value), do: value

  defp parse_option(key, value),
    do: raise("Invalid value for option #{inspect(key)}. Received #{inspect(value)}")

  defp maybe_atomize(term) when is_atom(term), do: term
  defp maybe_atomize(term) when is_binary(term), do: String.to_existing_atom(term)
end
