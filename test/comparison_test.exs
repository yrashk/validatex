Code.require_file "../test_helper", __FILE__

defmodule Validatex.ComparisonTest do
  use ExUnit.Case
  refer Validatex.Validate, as: V

  test :all do
    assert V.valid?(1,1)
    assert V.valid?(1,2) == :greater
    assert V.valid?(2,1) == :lesser
  end  

end