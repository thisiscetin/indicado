defmodule Indicado.MACD do
  @moduledoc """
  This is the MACD module used for calculating Moving Average Convergence Divergence
  """

  @doc """
  Calculates MACD for the list.

  Returns list of map `[{macd: x, signal: y}]` or `{:error, reason}`
  - `macd` represents macd calculation
  - `signal` represents signal line

  ## Examples

      iex> Indicado.MACD.eval([10, 15, 20, 30, 35, 40, 50], 2, 4, 3)
      {:ok, [%{macd: 1.333333333333334, signal: 0.666666666666667},
              %{macd: 2.5777777777777793, signal: 1.6222222222222231},
              %{macd: 4.80592592592593, signal: 3.2140740740740767},
              %{macd: 5.303308641975313, signal: 4.258691358024695},
              %{macd: 5.321902880658442, signal: 4.790297119341568},
              %{macd: 6.573114293552813, signal: 5.6817057064471905}]}

      iex> Indicado.MACD.eval([1, 2, 3, 4], 2, 4, 3)
      {:ok, [%{macd: 0.2666666666666666, signal: 0.1333333333333333},
              %{macd: 0.5155555555555553, signal: 0.3244444444444443},
              %{macd: 0.6945185185185183, signal: 0.5094814814814813}]}

      iex> Indicado.MACD.eval([], 4, 8, 6)
      {:error, :not_enough_data}

      iex> Indicado.MACD.eval([1, 2, 3, 4], 0, 4, 3)
      {:error, :bad_period}

      iex> Indicado.MACD.eval([1, 2, 3, 4], 2, 0, 3)
      {:error, :bad_period}

      iex> Indicado.MACD.eval([1, 2, 3, 4], 2, 4, 0)
      {:error, :bad_period}
  """
  @spec eval(list, pos_integer, pos_integer, pos_integer) ::
          {:ok, nonempty_list(map)} | {:error, :bad_period | :not_enough_data}
  def eval(list, fast_period, slow_period, signal_period),
    do: calc(list, fast_period, slow_period, signal_period)

  @doc """
  Calculates MACD for the list.

  Returns list of map `[{macd: x, signal: y}]` or `{:error, reason}`
  - `macd` represents macd calculation
  - `signal` represents signal line

  Raises `NotEnoughDataError` if the given list is empty.
  Raises `BadPeriodError` if any period is an unacceptable number.

  ## Examples

      iex> Indicado.MACD.eval!([1, 2, 3, 4], 2, 4, 3)
      [%{macd: 0.2666666666666666, signal: 0.1333333333333333},
        %{macd: 0.5155555555555553, signal: 0.3244444444444443},
        %{macd: 0.6945185185185183, signal: 0.5094814814814813}]

      iex> Indicado.MACD.eval!([], 4, 8, 6)
      ** (NotEnoughDataError) not enough data

      iex> Indicado.MACD.eval!([1, 2, 3, 4], 0, 4, 3)
      ** (BadPeriodError) bad period

      iex> Indicado.MACD.eval!([1, 2, 3, 4], 2, 0, 3)
      ** (BadPeriodError) bad period

      iex> Indicado.MACD.eval!([1, 2, 3, 4], 2, 4, 0)
      ** (BadPeriodError) bad period
  """
  @spec eval!(list, pos_integer, pos_integer, pos_integer) :: nonempty_list(map) | no_return
  def eval!(list, fast_period, slow_period, signal_period) do
    case calc(list, fast_period, slow_period, signal_period) do
      {:ok, result} -> result
      {:error, :not_enough_data} -> raise NotEnoughDataError
      {:error, :bad_period} -> raise BadPeriodError
    end
  end

  defp calc(list, fast_period, slow_period, signal_period)

  defp calc([], _fast_period, _slow_period, _signal_period), do: {:error, :not_enough_data}

  defp calc(_list, fast_period, _slow_period, _signal_period) when fast_period < 1,
    do: {:error, :bad_period}

  defp calc(_list, _fast_period, slow_period, _signal_period) when slow_period < 1,
    do: {:error, :bad_period}

  defp calc(_list, _fast_period, _slow_period, signal_period) when signal_period < 1,
    do: {:error, :bad_period}

  defp calc(list, fast_period, slow_period, signal_period) do
    fast_ema = Indicado.EMA.eval!(list, fast_period)
    slow_ema = Indicado.EMA.eval!(list, slow_period)
    macd = Enum.zip(fast_ema, slow_ema) |> Enum.map(fn {x, y} -> x - y end)

    {:ok,
     [macd, Indicado.EMA.eval!(macd, signal_period)]
     |> Enum.zip_with(fn [x, y] -> %{macd: x, signal: y} end)
     |> Enum.drop(1)}
  end
end
