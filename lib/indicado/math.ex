defmodule Indicado.Math do
  @moduledoc """
  This is the helper module holding common math functions for Indicado.
  """

  @doc """
  Calculates variance of a given numeric list.
  Returns `nil` if list is empty.

  ## Examples

      iex> Indicado.Math.variance([1, 2, 3, 4])
      1.25

      iex> Indicado.Math.variance([2, 4, 6, 8])
      5.0

      iex> Indicado.Math.variance([])
      nil
  """
  @spec variance(nonempty_list(list)) :: float
  def variance([]), do: nil

  def variance(list) do
    variance(list, mean(list))
  end

  @doc """
  Calculates variance of a given numeric list when mean is pre calculated and passed.
  Returns `nil` if list is empty.

  ## Examples

      iex> Indicado.Math.variance([1, 2, 3, 4], 2.5)
      1.25

      iex> Indicado.Math.variance([2, 4, 6, 8], 5.0)
      5.0

      iex> Indicado.Math.variance([])
      nil
  """
  @spec variance(nonempty_list(list), float) :: nil | float
  def variance([], _calculated_mean), do: nil

  def variance(list, calculated_mean) do
    list
    |> Enum.map(fn x -> (calculated_mean - x) * (calculated_mean - x) end)
    |> mean
  end

  @doc """
  Calculates standard deviation of a given numeric list.
  Returns `nil` if list is empty.

  ## Examples

      iex> Indicado.Math.stddev([1, 2, 3, 4])
      1.118033988749895

      iex> Indicado.Math.stddev([5, 10, 15, 20, 40])
      12.083045973594572

      iex> Indicado.Math.stddev([])
      nil
  """
  @spec stddev(nonempty_list(list)) :: float
  def stddev([]), do: nil
  def stddev(list), do: list |> variance |> :math.sqrt()

  @doc """
  Calculates standard deviation of a given numeric list when mean is pre calculated and passed.
  Returns `nil` if list is empty.

  ## Examples

      iex> Indicado.Math.stddev([1, 2, 3, 4], 2.5)
      1.118033988749895

      iex> Indicado.Math.stddev([5, 10, 15, 20, 40], 18)
      12.083045973594572

      iex> Indicado.Math.stddev([])
      nil
  """
  @spec stddev([list], float) :: nil | float
  def stddev([], _calculated_mean), do: nil
  def stddev(list, calculated_mean), do: list |> variance(calculated_mean) |> :math.sqrt()

  @doc """
  Calculated mean of a given numeric list.
  Returns `nil` if list is empty.

  ## Examples

      iex> Indicado.Math.mean([1, 2, 3, 4])
      2.5

      iex> Indicado.Math.mean([3, 5, 0, 14])
      5.5

      iex> Indicado.Math.mean([])
      nil
  """
  @spec mean(nonempty_list(list)) :: float
  def mean([]), do: nil

  def mean(list) do
    list
    |> Enum.sum()
    |> Kernel./(length(list))
  end
end
