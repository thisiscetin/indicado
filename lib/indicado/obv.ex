defmodule Indicado.OBV do
  @moduledoc """
  This is the OBV module used for calculating On-Balance Volume
  """

  @typedoc """
  The argument passed to eval functions should be a list of ovb_data_map type.
  """
  @type ovb_data_map :: %{
          close: float,
          volume: float
        }

  @doc """
   Calculates OBV for the list. The list argument passed to eval function should be list of ovb_data_map type.

   Returns `{:ok, ovb_list}` or `{:error, :not_enough_data}`

   ## Examples

       iex> Indicado.OBV.eval([%{close: 1, volume: 2}, %{close: 2, volume: 5}])
       {:ok, [5]}

       iex> Indicado.OBV.eval([%{close: 2, volume: 3}, %{close: 1, volume: 5}])
       {:ok, [-5]}

       iex> Indicado.OBV.eval([%{close: 2, volume: 3}, %{close: 1, volume: 5}, %{close: 2, volume: 4}])
       {:ok, [-5, -1]}

       iex> Indicado.OBV.eval([])
       {:error, :not_enough_data}

  """
  @spec eval(nonempty_list(ovb_data_map)) ::
          {:ok, nonempty_list(float)} | {:error, :not_enough_data}
  def eval(list), do: calc(list)

  @doc """
   Calculates OBV for the list. The list argument passed to eval function should be list of ovb_data_map type.

   Raises `NotEnoughDataError` if the given list lenght is zero.

   ## Examples

       iex> Indicado.OBV.eval!([%{close: 1, volume: 1}, %{close: 2, volume: 3}])
       [3]

       iex> Indicado.OBV.eval!([%{close: 1, volume: 1}, %{close: 1, volume: 3}])
       [0]

       iex> Indicado.OBV.eval!([])
       ** (NotEnoughDataError) not enough data

  """
  def eval!(list) do
    case calc(list) do
      {:ok, result} -> result
      {:error, :not_enough_data} -> raise NotEnoughDataError
    end
  end

  defp calc([]), do: {:error, :not_enough_data}

  defp calc(list) do
    {:ok,
     list
     |> Enum.chunk_every(2, 1, :discard)
     |> Enum.map(fn [x, y] -> ovb(y, x) end)
     |> sum}
  end

  defp sum(list, results \\ [])

  defp sum([head | tail], []), do: sum(tail, [head])

  defp sum([head | tail], [rhead | _rtail] = results) do
    sum(tail, [head + rhead | results])
  end

  defp sum([], results), do: Enum.reverse(results)

  defp ovb(last, prev) when last.close == prev.close, do: 0

  defp ovb(last, prev) when last.close > prev.close, do: last.volume

  defp ovb(last, prev) when last.close < prev.close, do: -last.volume
end
