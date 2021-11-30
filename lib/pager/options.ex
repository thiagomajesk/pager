defmodule Pager.Options do
  defstruct page_number: 1,
            page_size: 10,
            padding: 0,
            provider: nil,
            prefix: nil,
            without_count: false

  def merge(opts1, opts2) do
    opts1 = normalize(opts1)
    opts2 = normalize(opts2)
    merged = Keyword.merge(opts1, opts2)
    struct(__MODULE__, merged)
  end

  def from(opts) do
    opts = normalize(opts)
    struct(__MODULE__, opts)
  end

  defp normalize(opts) do
    (opts || [])
    |> Enum.to_list()
    |> atomize_keys()
    |> parse_values()
  end

  defp atomize_keys(opts) do
    Enum.map(opts, fn
      {k, v} when is_binary(k) ->
        {String.to_existing_atom(k), v}

      {k, v} ->
        {k, v}
    end)
  end

  # Accepts both standard keys and aliases
  defp parse_values(opts) do
    Enum.map(opts, fn
      {k, v} when k in [:page_number, :page] ->
        {:page_number, parse_option(k, v)}

      {k, v} when k in [:page_size, :size] ->
        {:page_size, parse_option(k, v)}

      {k, v} when k in [:padding, :skip] ->
        {:padding, parse_option(k, v)}

      kv ->
        kv
    end)
  end

  defp parse_option(key, value) when is_binary(value),
    do: parse_option(key, String.to_integer(value))

  defp parse_option(key, value) when is_integer(value) and value < 0,
    do: raise("Option #{inspect(key)} cannot be a negative number. Received #{inspect(value)}")

  defp parse_option(_key, value) when is_integer(value), do: value

  defp parse_option(key, value),
    do: raise("Invalid value for option #{inspect(key)}. Received #{inspect(value)}")
end
