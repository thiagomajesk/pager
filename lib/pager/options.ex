defmodule Pager.Options do
  @moduledoc false

  @default_page_number 1
  @default_page_size 10
  @default_padding 0

  def normalize(opts) do
    (opts || [])
    |> atomize_keys()
    |> patch_options()
    |> parse_values()
  end

  defp atomize_keys(opts) do
    Enum.into(opts, [], fn
      {k, v} when is_binary(k) ->
        {String.to_existing_atom(k), v}

      {k, v} ->
        {k, v}
    end)
  end

  defp patch_options(opts) do
    opts
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Keyword.put_new(:page_number, @default_page_number)
    |> Keyword.put_new(:page_size, @default_page_size)
    |> Keyword.put_new(:padding, @default_padding)
  end

  defp parse_values(opts) do
    Keyword.new(opts, fn
      {k, v} when k in [:page_number, :page] ->
        {:page_number, to_int(k, v)}

      {k, v} when k in [:page_size, :size] ->
        {:page_size, to_int(k, v)}

      {k, v} when k in [:padding, :skip] ->
        {:padding, to_int(k, v)}

      kv ->
        kv
    end)
  end

  defp to_int(option, value) when is_binary(value),
    do: check_value(option, String.to_integer(value))

  defp to_int(option, value) when is_integer(value), do: check_value(option, value)
  defp to_int(option, value), do: raise("Invalid value #{inspect(value)} for option #{option}")

  defp check_value(option, value) do
    if value < 0 do
      raise "Option #{option} cannot be a negative value"
    else
      value
    end
  end
end
