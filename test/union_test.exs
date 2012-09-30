defmodule Validatex.UnionTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.Union, as: Union

  test :positive do
    is_number = Validatex.Numericality.new
    is_string = Validatex.Type.new(is: :string)
    assert V.valid?(Union.new(options: [is_number, is_string]), 1)
    assert V.valid?(Union.new(options: [is_number, is_string]), "1")
  end  

  test :negative do
    is_number = Validatex.Numericality.new
    is_string = Validatex.Type.new(is: :string)
    assert List.sort(V.valid?(Union.new(options: [is_number, is_string]), make_ref)) == 
           List.sort([{is_number, :number_expected},{is_string,false}])
  end  

  test :non_false do
    is_atom = Validatex.Type.new(is: :atom, allow_nil: false)
    assert V.valid?(Union.new(options: [is_atom]), nil) == [{is_atom, :nil_not_allowed}]
  end

end
