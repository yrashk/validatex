defmodule Validatex.TypeTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.Type, as: T

  test :integer do
    assert V.valid?(T.new(is: :number),1) == true
    assert V.valid?(T.new(is: :integer),1) == true
  end

  test :float do 
    assert V.valid?(T.new(is: :number),1.1) == true
    assert V.valid?(T.new(is: :float),1.1) == true
  end

  test :atom, do: assert V.valid?(T.new(is: :atom), :atom) == true
  test :binary, do: assert V.valid?(T.new(is: :binary), <<>>) == true
  test :string, do: assert V.valid?(T.new(is: :string), "") == true
  test :ref, do: assert V.valid?(T.new(is: :reference), make_ref()) == true
  test :fun, do: assert V.valid?(T.new(is: :function), fn () -> :ok end) == true
  test :port, do: assert V.valid?(T.new(is: :port), hd(:erlang.ports)) == true
  test :pid, do: assert V.valid?(T.new(is: :pid), Process.self) == true
  test :tuple, do: assert V.valid?(T.new(is: :tuple), {}) == true
  test :list, do: assert V.valid?(T.new(is: :list), []) == true
  test :boolean do
    assert V.valid?(T.new(is: :boolean), true) == true
    assert V.valid?(T.new(is: :boolean), false) == true
  end
  test :nil, do: assert V.valid?(T.new(is: :nil), nil) == true

  test :allow_nil_atom do
    assert V.valid?(T.new(is: :atom, allow_nil: true), nil) == true
    assert V.valid?(T.new(is: :atom, allow_nil: false), nil) == :nil_not_allowed
  end

  test :allow_undefined_atom do
    assert V.valid?(T.new(is: :atom, allow_undefined: true), :undefined) == true
    assert V.valid?(T.new(is: :atom, allow_undefined: false), :undefined) == :undefined_not_allowed
  end

  test :allow_nil do
    assert not V.valid?(T.new(is: :string), nil) == true
    assert V.valid?(T.new(is: :string, allow_nil: true), nil)
  end

  test :allow_undefined do
    assert not V.valid?(T.new(is: :string), :undefined) == true
    assert V.valid?(T.new(is: :string, allow_undefined: true), :undefined)
  end


end
