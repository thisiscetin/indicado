defmodule Indicado.EMA do
  @moduledoc """
  This is the EMA module used for calculating Exponential Moving Average
  """

  @doc """
  Calculates EMA for the list. It needs non empty list of numbers and a positive
  period argument.

  Returns `{:ok, ema_list}` or `{:error, reason}`

  ## Examples

      iex> Indicado.EMA.eval([1, 2, 3, 4], 2)
      {:ok, [1.0, 1.6666666666666665, 2.5555555555555554, 3.518518518518518]}

      iex> Indicado.EMA.eval([2, 4, 5, 10, 100, 1000], 3)
      {:ok, [2.0, 3.0, 4.0, 7.0, 53.5, 526.75]}

      iex> Indicado.EMA.eval([2, 4, 5, 10, 100, 1000], 5)
      {:ok, [2.0, 2.666666666666667, 3.4444444444444446, 5.62962962962963, 37.08641975308642, 358.0576131687243]}

      iex> Indicado.EMA.eval([], 2)
      {:error, :not_enough_data}

      iex> Indicado.EMA.eval([1, 2, 3, 4], 0)
      {:error, :bad_period}

  """
  @spec eval(nonempty_list(list), pos_integer) :: {:ok, nonempty_list(float) | {:error, atom}}
  def eval(list, period), do: calc(list, period)

  @doc """
  Calculates EMA for the list. It needs non empty list of numbers and a positive
  period argument.

  Raises `NotEnoughDataError` if the given list is not longh enough for calculating RSI.
  Raises `BadPeriodError` if period is an unacceptable number.

  ## Examples

      iex> Indicado.EMA.eval!([1, 2, 3, 4], 2)
      [1.0, 1.6666666666666665, 2.5555555555555554, 3.518518518518518]

      iex> Indicado.EMA.eval!([], 2)
      ** (NotEnoughDataError) not enough data

      iex> Indicado.EMA.eval!([1, 3, 4], 0)
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

  defp calc([head | tail], period, []) do
    calc(tail, period, [calc_ema(head, period, head)])
  end

  defp calc([head | tail], period, results) do
    [result_head | _result_tail] = results
    calc(tail, period, [calc_ema(head, period, result_head) | results])
  end

  defp calc_ema(last, period, prev_ema) do
    multiplier = 2 / (period + 1)
    last * multiplier + prev_ema * (1 - multiplier)
  end
end
