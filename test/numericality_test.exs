Code.require_file "../test_helper", __FILE__

defmodule Validatex.NumericalityTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.Numericality, as: N

  test :undefined do
    assert V.valid?(N.new, :undefined) == :undefined_not_allowed
    assert V.valid?(N.new(allow_undefined: false), :undefined) == :undefined_not_allowed
    assert V.valid?(N.new(allow_undefined: true), :undefined)
  end

  test :nil do
    assert V.valid?(N.new, nil) == :nil_not_allowed
    assert V.valid?(N.new(allow_nil: false), nil) == :nil_not_allowed
    assert V.valid?(N.new(allow_nil: true), nil)
  end

  test :list do
    assert V.valid?(N.new, '') == :list_not_allowed
    assert V.valid?(N.new(allow_list: false), '') == :list_not_allowed
    assert V.valid?(N.new(allow_list: true, allow_empty: true), '')
  end

  test :empty do
    assert V.valid?(N.new(allow_empty: true), "") == :string_not_allowed
    assert V.valid?(N.new(allow_empty: true, allow_string: true), "")
    assert V.valid?(N.new(allow_empty: false, allow_string: true), "") == :empty_not_allowed
    assert V.valid?(N.new(allow_string: true), "") == :empty_not_allowed
  end

  test :string do
    assert V.valid?(N.new(allow_string: true), "1")
    assert V.valid?(N.new(allow_string: true, allow_rest: true), "1a")
    assert V.valid?(N.new(allow_string: true), "1a") == :rest_not_allowed
    assert V.valid?(N.new(allow_string: true), "1.1")
    assert V.valid?(N.new(allow_string: true, allow_rest: true), "1.1a") 
    assert V.valid?(N.new(allow_string: true), "garbage") == :number_expected
  end

  test :allow_float do
    assert V.valid?(N.new, 1.1)
    assert V.valid?(N.new(allow_float: false), 1.1) == :float_not_allowed
  end

  test :default do
    assert V.valid?(N.new(allow_undefined: true), :undefined)
    assert V.valid?(N.new(allow_nil: true), nil)
    assert V.valid?(N.new(allow_string: true, allow_empty: true), "")
    assert V.valid?(N.new(allow_list: true, allow_string: true, allow_empty: true), '')

    assert V.valid?(N.new(default: 1, allow_undefined: true), :undefined)
    assert V.valid?(N.new(default: 1, allow_nil: true), nil)
    assert V.valid?(N.new(default: 1, allow_string: true, allow_empty: true), "")
    assert V.valid?(N.new(default: 1, allow_list: true, allow_string: true, allow_empty: true), '')

    assert V.valid?(N.new(default: :x, allow_undefined: true), :undefined) == :number_expected
    assert V.valid?(N.new(default: :x, allow_nil: true), nil) == :number_expected
    assert V.valid?(N.new(default: :x, allow_string: true, allow_empty: true), "") == :number_expected
    assert V.valid?(N.new(default: :x, allow_list: true, allow_string: true, allow_empty: true), '') == :number_expected
  end



end
