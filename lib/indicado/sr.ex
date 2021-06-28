defmodule Indicado.SR do
  @moduledoc """
  This is the SR module used for calculating Stochastic Oscillator.
  """
  @doc """
  Calculates SR for the list.

  Returns `{:ok, rs_list}` or `{:error, reason}`

  ## Examples

      iex> Indicado.SR.eval([1, 3, 4, 3, 1, 5], 4)
      {:ok, [66.66666666666666, 0.0, 100.0]}

      iex> Indicado.SR.eval([1, 10, 5, 3, 9, 12, 6, 3, 4], 5)
      {:ok, [88.88888888888889, 100.0, 33.33333333333333, 0.0, 11.11111111111111]}

      iex> Indicado.SR.eval([1, 3], 3)
      {:error, :not_enough_data}

      iex> Indicado.SR.eval([1, 3, 4], 0)
      {:error, :bad_period}

  """
  @spec eval(nonempty_list(list), pos_integer) :: {:ok, nonempty_list(float)} | {:error, atom}
  def eval(list, period), do: calc(list, period)

  @doc """
  Calculates SR for the list. Raises exceptions when arguments does not satisfy needed conditions to calculate SR.

  Raises `NotEnoughDataError` if the given list is not longh enough for calculating RS.
  Raises `BadPeriodError` if period is an unacceptable number.

  ## Examples

      iex> Indicado.SR.eval!([1, 3, 5, 7], 2)
      [100.0, 100.0, 100.0]

      iex> Indicado.SR.eval!([1, 3], 3)
      ** (NotEnoughDataError) not enough data

      iex> Indicado.SR.eval!([1, 3, 4], 0)
      ** (BadPeriodError) bad period

  """
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

  defp calc([_head | tail] = list, period, results) when length(list) < period do
    calc(tail, period, results)
  end

  defp calc([_head | tail] = list, period, result) do
    [close | _] =
      list
      |> Enum.take(period)
      |> Enum.take(-1)

    {min, max} =
      list
      |> Enum.take(period)
      |> Enum.min_max()

    k = (close - min) / (max - min) * 100
    calc(tail, period, [k | result])
  end
end
