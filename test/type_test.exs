defmodule Validatex.TypeTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.Type, as: T

  test :integer do
    assert V.valid?(T.new(is: :number),1)
    assert V.valid?(T.new(is: :integer),1)
  end

  test :float do 
    assert V.valid?(T.new(is: :number),1.1)
    assert V.valid?(T.new(is: :float),1.1)
  end

  test :atom, do: assert V.valid?(T.new(is: :atom), :atom)
  test :binary, do: assert V.valid?(T.new(is: :binary), <<>>)
  test :string, do: assert V.valid?(T.new(is: :string), "")
  test :ref, do: assert V.valid?(T.new(is: :reference), make_ref())
  test :fun, do: assert V.valid?(T.new(is: :function), fn () -> :ok end)
  test :port, do: assert V.valid?(T.new(is: :port), hd(:erlang.ports))
  test :pid, do: assert V.valid?(T.new(is: :pid), Process.self)
  test :tuple, do: assert V.valid?(T.new(is: :tuple), {})
  test :list, do: assert V.valid?(T.new(is: :list), [])
  test :boolean do
    assert V.valid?(T.new(is: :boolean), true)
    assert V.valid?(T.new(is: :boolean), false)
  end
  test :nil, do: assert V.valid?(T.new(is: :nil), nil)

end
