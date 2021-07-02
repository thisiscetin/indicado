defmodule Indicado.WR do
  @moduledoc """
  This is the WR module used for calculating Williams %R.
  """

  @doc """
  Calculates WR for the list.

  Returns `{:ok, rs_list}` or `{:error, reason}`

  ## Examples

      iex> Indicado.WR.eval([1, 3, 4, 3, 1, 5], 4)
      {:ok, [0.3333333333333333, 1.0, 0.0]}

      iex> Indicado.WR.eval([1, 10, 5, 3, 9, 12, 6, 3, 4], 5)
      {:ok, [0.1111111111111111, 0.0, 0.6666666666666666, 1.0, 0.8888888888888888]}

      iex> Indicado.WR.eval([1, 3], 3)
      {:error, :not_enough_data}

      iex> Indicado.WR.eval([1, 5], 0)
      {:error, :bad_period}

  """
  @spec eval(nonempty_list(list), pos_integer) :: {:ok, nonempty_list(float)} | {:error, atom}
  def eval(list, period), do: calc(list, period)

  @doc """
  Calculates WR for the list. Raises exceptions when arguments does not satisfy needed conditions to calculate WR.

  Raises `NotEnoughDataError` if the given list is not long enough for calculating WR.

  Raises `BadPeriodError` if period is an unacceptable number.

  ## Examples

      iex> Indicado.WR.eval!([1, 3, 4, 3, 1, 5], 4)
      [0.3333333333333333, 1.0, 0.0]

      iex> Indicado.WR.eval!([1, 3], 3)
      ** (NotEnoughDataError) not enough data

      iex> Indicado.WR.eval!([1, 5], 0)
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

  defp calc([_head | tail] = list, period, results) when length(list) < period do
    calc(tail, period, results)
  end

  defp calc([_head | tail] = list, period, results) do
    [close | _] =
      list
      |> Enum.take(period)
      |> Enum.take(-1)

    {min, max} =
      list
      |> Enum.take(period)
      |> Enum.min_max()

    wr = (max - close) / (max - min)
    calc(tail, period, [wr | results])
  end
end
