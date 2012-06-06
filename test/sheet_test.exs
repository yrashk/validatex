Code.require_file "../test_helper", __FILE__

defmodule Validatex.SheetTest do
  use ExUnit.Case
  alias Validatex, as: V

  test :no_errors do
    plan = [{"age", "30", V.Numericality.new(allow_string: true)}]
    assert V.validate(plan) == []
  end

  test :errors do
    plan = [{"age", "30", V.Numericality.new(allow_string: false)},
            {"age", 30, V.Range.new(to: 18)}
           ]
    assert length(V.validate(plan)) == 2
  end

end
