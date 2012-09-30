defmodule Validatex.AllTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.All, as: All

  test :positive do
    format = Validatex.Format.new(re: %r/.*/i)
    is_string = Validatex.Type.new(is: :string)
    assert V.valid?(All.new(options: [format, is_string]), "1") == true
  end  

  test :negative do
    is_number = Validatex.Numericality.new
    is_string = Validatex.Type.new(is: :string)
    assert V.valid?(All.new(options: [is_number, is_string]), "1") == 
           [{is_number, :string_not_allowed}]
  end  
end