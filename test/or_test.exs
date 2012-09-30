defmodule Validatex.OrTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.Or, as: Or

  test :positive do
    is_number = Validatex.Numericality.new
    is_string = Validatex.Type.new(is: :string)
    assert V.valid?(Or.new(options: [is_number, is_string]), 1)
    assert V.valid?(Or.new(options: [is_number, is_string]), "1")
  end  

  test :negative do
    is_number = Validatex.Numericality.new
    is_string = Validatex.Type.new(is: :string)
    assert V.valid?(Or.new(options: [is_number, is_string]), make_ref)
  end  

end
