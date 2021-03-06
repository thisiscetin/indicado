defmodule Indicado.SMA do
  @moduledoc """
  This is the SMA module used for calculating Simple Moving Average.
  """

  @doc """
  Calculates SMA for the list.

  Returns `{:ok, sma_list}` or `{:error, reason}`

  ## Examples

      iex> Indicado.SMA.eval([1, 3, 5, 7], 2)
      {:ok, [2.0, 4.0, 6.0]}

      iex> Indicado.SMA.eval([1, 3], 3)
      {:error, :not_enough_data}

      iex> Indicado.SMA.eval([1, 3, 4], 0)
      {:error, :bad_period}

  """
  @spec eval(nonempty_list(list), pos_integer) :: {:ok, nonempty_list(float)} | {:error, atom}
  def eval(list, period), do: calc(list, period)

  @doc """
  Calculates SMA for the list. Raises exceptions when arguments does not satisfy needed conditions
  to calculate SMA.

  Raises `NotEnoughDataError` if the given list is not longh enough for calculating SMA.
  Raises `BadPeriodError` if period is an unacceptable number.

  ## Examples

      iex> Indicado.SMA.eval!([1, 3, 5, 7], 2)
      [2.0, 4.0, 6.0]

      iex> Indicado.SMA.eval!([1, 3], 3)
      ** (NotEnoughDataError) not enough data

      iex> Indicado.SMA.eval!([1, 3, 4], 0)
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
    avg =
      list
      |> Enum.take(period)
      |> Enum.sum()
      |> Kernel./(period)

    calc(tail, period, [avg | results])
  end
end
