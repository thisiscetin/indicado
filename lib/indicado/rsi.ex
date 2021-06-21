defmodule Indicado.RSI do
  @moduledoc """
  This is the RSI module used for calculating Relative Strength Index
  """

  @doc """
  Calculates RSI for the list. It needs list of numbers and the length of
  list argument should at least be 1 more than period.

  Returns `{:ok, rsi_list}` or `{:error, reason}`

  ## Examples

      iex> Indicado.RSI.eval([1, 2, 3, 4, 5, 6], 2)
      {:ok, [100.0, 100.0, 100.0, 100.0]}

      iex> Indicado.RSI.eval([5, 4, 3, 2, 1, 0], 4)
      {:ok, [0.0, 0.0]}

      iex> Indicado.RSI.eval([2, 4, 6, 7, 2, 1, 5, 10], 3)
      {:ok, [100.0, 37.5, 14.285714285714292, 39.99999999999999, 90.0]}

      iex> Indicado.RSI.eval([], 2)
      {:error, :not_enough_data}

      iex> Indicado.RSI.eval([1, 5, 10], 3)
      {:error, :not_enough_data}

      iex> Indicado.RSI.eval([1, 4], 0)
      {:error, :bad_period}

  """
  @spec eval(nonempty_list(list), pos_integer) :: {:ok, nonempty_list(float) | {:error, atom}}
  def eval(list, period), do: calc(list, period)

  @doc """
  Calculates RSI for the list. It needs list of numbers and the length of
  list argument should at least be 1 more than period.

  Raises `NotEnoughDataError` if the given list is not longh enough for calculating RSI.
  Raises `BadPeriodError` if period is an unacceptable number.

  ## Examples

      iex> Indicado.RSI.eval!([1, 3, 5, 7], 2)
      [100.0, 100.0]

      iex> Indicado.RSI.eval!([1, 3], 3)
      ** (NotEnoughDataError) not enough data

      iex> Indicado.RSI.eval!([1, 3, 4], 0)
      ** (BadPeriodError) bad period

  """
  @spec eval!(nonempty_list(list), pos_integer) :: nonempty_list(float) | no_return
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

  defp calc([_head | tail] = list, period, results) do
    cond do
      length(list) >= period + 1 ->
        {pos_values, neg_values} =
          list
          |> Enum.take(period + 1)
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.map(fn [x, y] -> y - x end)
          |> Enum.split_with(fn x -> x > 0 end)

        avg_gain =
          pos_values
          |> Enum.sum()
          |> Kernel./(period)

        avg_loss =
          neg_values
          |> Enum.sum()
          |> Kernel./(period)
          |> abs

        if avg_loss == 0 do
          calc(tail, period, [100.0 | results])
        else
          rs = avg_gain / avg_loss
          rsi = 100.0 - 100.0 / (1.0 + rs)

          calc(tail, period, [rsi | results])
        end

      true ->
        calc(tail, period, results)
    end
  end
end
