defmodule Indicado.ADI do
  @moduledoc """
  This is the ADI module used for calculating Accumulation Distribution Line.
  """

  @typedoc """
  The argument passed to eval functions should be a list of adi_data_map type.
  """
  @type adi_data_map :: %{
          low: float,
          high: float,
          close: float,
          volume: float
        }

  @doc """
  Calculates ADI for the list. The list argument passed to eval function should be list of adi_data_map type.

  Returns `{:ok, adi_ist}` or `{:error, reason}`

  ## Examples

      iex> Indicado.ADI.eval([%{low: 1.0, high: 11.0, close: 10.0, volume: 5.7}, %{low: 2.0, high: 6.0, close: 3.0, volume: 11.5}, %{low: 3.0, high: 7.0, close: 4.0, volume: 2.0}, %{low: 4.0, high: 20.3, close: 18.0, volume: 20.2}])
      {:ok, [4.5600000000000005, -1.1899999999999995, -2.1899999999999995, 12.309386503067484]}


      iex> Indicado.ADI.eval([%{low: 1.0, high: 4.0, close: 3.0, volume: 2.0}])
      {:ok, [0.6666666666666666]}

      iex> Indicado.ADI.eval([])
      {:error, :not_enough_data}

  """
  @spec eval(nonempty_list(adi_data_map)) :: {:ok, nonempty_list(float)} | {:error, atom}
  def eval(list), do: calc(list)

  @doc """
  Calculates ADI for the list. The list argument passed to eval function should be list of adi_data_map type spec. Raises exceptions when arguments does not satisfy needed conditions.

  Returns `adi_ist` or,
  Raises `NotEnoughDataError` if the given list lenght is zero.

  ## Examples


      iex> Indicado.ADI.eval!([%{low: 1.0, high: 4.0, close: 3.0, volume: 2.0}])
      [0.6666666666666666]

      iex> Indicado.ADI.eval!([])
      ** (NotEnoughDataError) not enough data

  """
  def eval!(list) do
    case calc(list) do
      {:ok, result} -> result
      {:error, :not_enough_data} -> raise NotEnoughDataError
    end
  end

  defp calc(list, results \\ [])

  defp calc([], []), do: {:error, :not_enough_data}

  defp calc([], results), do: {:ok, Enum.reverse(results)}

  defp calc([head | tail], []) do
    calc(tail, [clv(head) * head.volume])
  end

  defp calc([head | tail], [rhead | _rtail] = results) do
    calc(tail, [rhead + clv(head) * head.volume | results])
  end

  defp clv(row) when row.high != row.low do
    (row.close - row.low - (row.high - row.close)) / (row.high - row.low)
  end

  defp clv(_row) do
    0
  end
end
