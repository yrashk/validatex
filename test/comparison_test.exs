defmodule Validatex.ComparisonTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V

  test :all do
    assert V.valid?(1,1)
    assert V.valid?(1,2) == :greater
    assert V.valid?(2,1) == :lesser
  end  

end
