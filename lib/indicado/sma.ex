defmodule Indicado.Sma do
  @moduledoc """
  This is the SMA module.
  """

  @doc """
  A simple moving average (SMA) calculates the average of a selected range of numbers.

  ## Examples
    iex> Indicado.Sma.sma([])
    nil

    iex> Indicado.Sma.sma([1.0, 2.0, 3.0])
    2.0

    iex> Indicado.Sma.sma([1.5, -1.5, 3.0])
    1.0
  """
  def sma([]), do: nil

  @spec sma(nonempty_list(list)) :: float
  def sma(list) do
    Enum.sum(list) / Kernel.length(list)
  end
end
