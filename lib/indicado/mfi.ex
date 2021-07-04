defmodule Indicado.MFI do
  @moduledoc """
  This is the MFI module used for calculating Money Flow Index
  """

  @typedoc """
  The argument passed to eval functions should be a list of mfi_data_map type.
  """
  @type mfi_data_map :: %{
          low: float,
          high: float,
          close: float,
          volume: float
        }

  @doc """
  Calculates MFI for the list. It needs list of mfi_data_map and lenght of list should be at least 1 higher then period.

  Returns `{:ok, mfi_list}` or `{:error, reason}`

  ## Examples

      iex> Indicado.MFI.eval([%{low: 1, high: 3, close: 2, volume: 1}, %{low: 2, high: 4, close: 3, volume: 2}, %{low: 1, high: 2, close: 2, volume: 5}, %{low: 3, high: 5, close: 4, volume: 1}], 2)
      {:ok, [41.860465116279066, 32.432432432432435]}

      iex> Indicado.MFI.eval([%{low: 2, high: 4, close: 4, volume: 1}, %{low: 2, high: 5, close: 3, volume: 5}, %{low: 5, high: 8, close: 5, volume: 5}, %{low: 3, high: 5, close: 5, volume: 3}, %{low: 1, high: 3, close: 2, volume: 10}], 3)
      {:ok, [69.76744186046511, 47.61904761904762]}

      iex> Indicado.MFI.eval([%{low: 1, high: 3, close: 2, volume: 1}, %{low: 2, high: 4, close: 3, volume: 2}, %{low: 1, high: 2, close: 2, volume: 5}, %{low: 3, high: 5, close: 4, volume: 1}], 5)
      {:error, :not_enough_data}

      iex> Indicado.MFI.eval([%{low: 1, high: 3, close: 2, volume: 1}, %{low: 2, high: 4, close: 3, volume: 2}, %{low: 1, high: 2, close: 2, volume: 5}, %{low: 3, high: 5, close: 4, volume: 1}], 0)
      {:error, :bad_period}

  """
  @spec eval(nonempty_list(mfi_data_map), pos_integer) ::
          {:ok, nonempty_list(float) | {:error, atom}}
  def eval(list, period), do: calc(list, period)

  @doc """
  Calculates MFI for the list. It needs list of mfi_data_map and lenght of list should be at least 1 higher then period.

  Raises `NotEnoughDataError` if the given list is not longh enough for calculating MFI.
  Raises `BadPeriodError` if period is an unacceptable number.

  ## Examples

      iex> Indicado.MFI.eval!([%{low: 1, high: 3, close: 2, volume: 1}, %{low: 2, high: 4, close: 3, volume: 2}, %{low: 1, high: 2, close: 2, volume: 5}, %{low: 3, high: 5, close: 4, volume: 1}], 2)
      [41.860465116279066, 32.432432432432435]

      iex> Indicado.MFI.eval!([%{low: 1, high: 3, close: 2, volume: 1}, %{low: 2, high: 4, close: 3, volume: 2}, %{low: 1, high: 2, close: 2, volume: 5}, %{low: 3, high: 5, close: 4, volume: 1}], 5)
      ** (NotEnoughDataError) not enough data

      iex> Indicado.MFI.eval!([%{low: 1, high: 3, close: 2, volume: 1}, %{low: 2, high: 4, close: 3, volume: 2}, %{low: 1, high: 2, close: 2, volume: 5}, %{low: 3, high: 5, close: 4, volume: 1}], 0)
      ** (BadPeriodError) bad period

  """
  @spec eval!(nonempty_list(mfi_data_map), pos_integer) :: nonempty_list(float) | no_return
  def eval!(list, period) do
    case calc(list, period) do
      {:ok, result} -> result
      {:error, :not_enough_data} -> raise NotEnoughDataError
      {:error, :bad_period} -> raise BadPeriodError
    end
  end

  defp calc(list, period, results \\ [])

  defp calc([], _period, []), do: {:error, :not_enough_data}

  defp calc(_list, period, _results) when period < 1, do: {:error, :bad_period}

  defp calc([], _period, results), do: {:ok, Enum.reverse(results)}

  defp calc([_head | tail] = list, period, results) when length(list) < period + 1 do
    calc(tail, period, results)
  end

  defp calc([_head | tail] = list, period, results) do
    money_flows =
      list
      |> Enum.take(period + 1)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [x, y] -> money_flow(x, y) end)
      |> Enum.group_by(fn x -> if x > 0, do: :pos, else: :neg end)
      |> Map.new(fn
        {type, []} -> {type, nil}
        {type, values} -> {type, Enum.sum(values)}
      end)
      |> Map.put_new(:pos, 0.0)
      |> Map.put_new(:neg, 0.0)

    if money_flows.neg == 0 do
      calc(tail, period, [100 | results])
    else
      mfr = money_flows.pos / abs(money_flows.neg)
      mfi = 100 - 100 / (1 + mfr)

      calc(tail, period, [mfi | results])
    end
  end

  defp money_flow(x, y) do
    case typical_price(y) - typical_price(x) do
      n when n > 0 -> typical_price(y) * y.volume
      n when n < 0 -> -1 * typical_price(y) * y.volume
      _ -> 0
    end
  end

  defp typical_price(row), do: (row.high + row.low + row.close) / 3
end
