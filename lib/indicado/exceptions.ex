defmodule BadPeriodError do
  defexception message: "bad period"
end

defmodule BadDeviationError do
  defexception message: "bad deviation"
end

defmodule NotEnoughDataError do
  defexception message: "not enough data"
end
