defmodule Indicado.Bollinger do
  @moduledoc """
  This is the Bollinger module used for calculating Bollinger Bands.
  """

  @doc """
  Calculates BB for the list.

  Returns list of map `[{lower: x, mean: y, upper: z}]` or `{:error, reason}`
  - `lower` represents low band of bollinger band
  - `mean` represents mean value
  - `upper` represents upper value of bollinger band

  ## Examples

      iex> Indicado.Bollinger.eval([1, 2, 3, 4, 5], 2, 2)
      {:ok, [%{lower: 0.5, mean: 1.5, upper: 2.5},
              %{lower: 1.5, mean: 2.5, upper: 3.5},
              %{lower: 2.5, mean: 3.5, upper: 4.5},
              %{lower: 3.5, mean: 4.5, upper: 5.5}]}

      iex> Indicado.Bollinger.eval([1, 2, 3, 4, 5], 2, 3)
      {:ok, [%{lower: 0.0, mean: 1.5, upper: 3.0},
              %{lower: 1.0, mean: 2.5, upper: 4.0},
              %{lower: 2.0, mean: 3.5, upper: 5.0},
              %{lower: 3.0, mean: 4.5, upper: 6.0}]}

      iex> Indicado.Bollinger.eval([1, 2, 3, 4, 5], 0, 3)
      {:error, :bad_period}

      iex> Indicado.Bollinger.eval([1, 2, 3, 4, 5], 5, 0)
      {:error, :bad_deviation}
  """
  @spec eval(list, pos_integer, pos_integer) :: {:ok, nonempty_list(map)} | {:error, atom}
  def eval(list, period, devation), do: calc(list, period, devation)

  @doc """
  Calculates BB for the list. Raises exceptions when argument does not satisfy needed conditions
  to calculate Bollinger Bands.

  Returns list of map `[{lower: x, mean: y, upper: z}]` or `{:error, reason}`
  - `lower` represents low band of bollinger band
  - `mean` represents mean value
  - `upper` represents upper value of bollinger band

  Raises `NotEnoughDataError` if the given list is not longh enough for calculating SMA.
  Raises `BadPeriodError` if period is an unacceptable number.
  Raises `BadDeviationError` if deviation is an unacceptable number.

  ## Examples

      iex> Indicado.Bollinger.eval!([1, 2, 3, 4, 5], 2, 2)
      [%{lower: 0.5, mean: 1.5, upper: 2.5},
        %{lower: 1.5, mean: 2.5, upper: 3.5},
        %{lower: 2.5, mean: 3.5, upper: 4.5},
        %{lower: 3.5, mean: 4.5, upper: 5.5}]

      iex> Indicado.Bollinger.eval!([1, 2, 3, 4, 5], 2, 3)
      [%{lower: 0.0, mean: 1.5, upper: 3.0},
        %{lower: 1.0, mean: 2.5, upper: 4.0},
        %{lower: 2.0, mean: 3.5, upper: 5.0},
        %{lower: 3.0, mean: 4.5, upper: 6.0}]

      iex> Indicado.Bollinger.eval!([], 2, 3)
      ** (NotEnoughDataError) not enough data

      iex> Indicado.Bollinger.eval!([1, 2, 3, 4, 5], 0, 3)
      ** (BadPeriodError) bad period

      iex> Indicado.Bollinger.eval!([1, 2, 3, 4, 5], 5, 0)
      ** (BadDeviationError) bad deviation
  """
  @spec eval!(list, pos_integer, pos_integer) :: nonempty_list(map) | no_return
  def eval!(list, period, deviation) do
    case calc(list, period, deviation) do
      {:ok, result} -> result
      {:error, :not_enough_data} -> raise NotEnoughDataError
      {:error, :bad_period} -> raise BadPeriodError
      {:error, :bad_deviation} -> raise BadDeviationError
    end
  end

  defp calc(list, period, deviation, results \\ [])

  defp calc(_list, period, _deviation, _result) when period < 1, do: {:error, :bad_period}

  defp calc(_list, _period, deviation, _result) when deviation < 1, do: {:error, :bad_deviation}

  defp calc([], _period, _deviation, []), do: {:error, :not_enough_data}

  defp calc([], _period, _deviation, results), do: {:ok, Enum.reverse(results)}

  defp calc([_head | tail] = list, period, deviation, results) do
    cond do
      length(list) >= period ->
        row =
          list
          |> Enum.take(period)
          |> bb_row(deviation)

        calc(tail, period, deviation, [row | results])

      true ->
        calc(tail, period, deviation, results)
    end
  end

  defp bb_row(list, deviation) do
    mean = Indicado.Math.mean(list)
    stddev = Indicado.Math.stddev(list, mean)

    %{lower: mean - stddev * deviation, mean: mean, upper: mean + stddev * deviation}
  end
end
