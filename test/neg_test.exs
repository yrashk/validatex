defmodule Validatex.NegTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.Neg, as: Neg

  test :positive do
    is_number = Validatex.Numericality.new
    assert V.valid?(Neg.new(validation: is_number), "a")
  end  

  test :negative do
    is_number = Validatex.Numericality.new
    assert not V.valid?(Neg.new(validation: is_number), 1)
  end  

  test :message do
    is_number = Validatex.Numericality.new
    assert V.valid?(Neg.new(validation: is_number, message: :not), 1) == :not
  end  


end
