Code.require_file "../test_helper", __FILE__

defmodule Validatex.CustomTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V

  defrecord MyValidator, q: nil

  defimpl Validatex.Validate, for: MyValidator do
     alias MyValidator, as: V
     def valid?(V[], v), do: v
  end

  test :all do
    assert V.valid?(MyValidator.new, true)
    assert V.valid?(MyValidator.new, :something) == :something
  end

end
