defmodule Validatex.FormatTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.Format, as: F

  test :undefined do
    assert V.valid?(F.new, :undefined) == :undefined_not_allowed
    assert V.valid?(F.new(allow_undefined: false), :undefined) == :undefined_not_allowed
    assert V.valid?(F.new(allow_undefined: true, allow_empty: true), :undefined)
  end

  test :nil do
    assert V.valid?(F.new, nil) == :nil_not_allowed
    assert V.valid?(F.new(nil_undefined: false), nil) == :nil_not_allowed
    assert V.valid?(F.new(allow_nil: true, allow_empty: true), nil) == true
  end

  test :empty do
    assert V.valid?(F.new(allow_empty: true), "") == true
    assert V.valid?(F.new(allow_list: true, allow_empty: true), '') == true
    assert V.valid?(F.new(allow_empty: false), "") == :empty_not_allowed
    assert V.valid?(F.new(allow_empty: false, allow_list: true), '') == :empty_not_allowed
    assert V.valid?(F.new, "") == :empty_not_allowed
    assert V.valid?(F.new(allow_list: true), '') == :empty_not_allowed
  end

  test :regex do
    assert V.valid?(F.new(re: %r/^1$/),"1") == true
    assert V.valid?(F.new(re: %r/^1$/),"2") == :no_match
  end

  test :string do
    assert V.valid?(F.new(re: "^1$"),"1") == true
    assert V.valid?(F.new(re: "^1$"),"2") == :no_match
  end

  test :default do
    assert V.valid?(F.new(allow_undefined: true, allow_empty: true), :undefined) == true
    assert V.valid?(F.new(allow_nil: true, allow_empty: true), nil) == true
    assert V.valid?(F.new(allow_empty: true), "") == true
    assert V.valid?(F.new(allow_empty: true, allow_list: true), '') == true
    assert V.valid?(F.new(allow_undefined: true, allow_empty: true, default: :x), :undefined) == :string_expected
    assert V.valid?(F.new(allow_nil: true, allow_empty: true, default: :x), nil) == :string_expected
  end

end
