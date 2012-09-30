defmodule Validatex.AndTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.And, as: And

  test :positive do
    format = Validatex.Format.new(re: %r/.*/i)
    is_string = Validatex.Type.new(is: :string)
    assert V.valid?(And.new(options: [format, is_string]), "1")
  end  

  test :negative do
    is_number = Validatex.Numericality.new
    is_string = Validatex.Type.new(is: :string)
    assert V.valid?(And.new(options: [is_number, is_string]), "1")
  end  

end
