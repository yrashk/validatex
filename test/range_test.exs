defmodule Validatex.RangeTest do
  use ExUnit.Case
  alias Validatex.Validate, as: V
  alias Validatex.Range, as: R

  ## until we can use PropEr in Elixir, lets use some
  ## manual testing (unlike in Validaterl)
  test :inclusive do
    assert inclusive_test(nil, nil, 1)
    assert inclusive_test(0, 1, 1)
    assert inclusive_test(0, 1, 2)
    assert inclusive_test(0, 1, 0.5)
    assert inclusive_test(0, 1, -0.5)
    assert inclusive_test(0, 1, :atom)

    assert inclusive_test(0, nil, 1)
    assert inclusive_test(0, nil, 2)
    assert inclusive_test(0, nil, 0.5)
    assert inclusive_test(0, nil, -0.5)
    assert inclusive_test(0, nil, :atom)

    assert inclusive_test(nil, 1, 1)
    assert inclusive_test(nil, 1, 2)
    assert inclusive_test(nil, 1, 0.5)
    assert inclusive_test(nil, 1, -0.5)
    assert inclusive_test(nil, 1, :atom)
  end

  test :exclusive do
    assert exclusive_test(nil, nil, 1)
    assert exclusive_test(0, 1, 1)
    assert exclusive_test(0, 1, 2)
    assert exclusive_test(0, 1, 0.5)
    assert exclusive_test(0, 1, -0.5)
    assert exclusive_test(0, 1, :atom)

    assert exclusive_test(0, nil, 1)
    assert exclusive_test(0, nil, 2)
    assert exclusive_test(0, nil, 0.5)
    assert exclusive_test(0, nil, -0.5)
    assert exclusive_test(0, nil, :atom)

    assert exclusive_test(nil, 1, 1)
    assert exclusive_test(nil, 1, 2)
    assert exclusive_test(nil, 1, 0.5)
    assert exclusive_test(nil, 1, -0.5)
    assert exclusive_test(nil, 1, :atom)
  end

  defp inclusive_test(from, to, value) do
       validate = V.valid?(R.new(from: from, to: to), value)
       cond do
          from !== nil and value < from ->
             validate == :lesser
          to !== nil and value > to ->
             validate == :greater
          from !== nil and to !== nil and value >= from and value <= to ->
             validate == true
          from === nil and to !== nil and value <= to ->
             validate == true
          to === nil and from !== nil and value >= from ->
             validate == true
          from === nil and to === nil ->
             validate == true
          value < from ->
             validate == :lesser
          value > to ->
             validate == :greater
          true ->
             false
       end
  end

  defp exclusive_test(from, to, value) do
       validate = V.valid?(R.new(from: from, to: to, exclusive: true), value)
       cond do
         from !== nil and value <= from and from == to ->
              (validate == :lesser) or (validate == :greater)
         from !== nil and value <= from ->
              validate == :lesser
         to !== nil and value >= to and from == to ->
              (validate == :lesser) or (validate == :greater)
         to !== nil and value >= to ->
              validate == :greater
         from !== nil and to !== nil and value > from and value < to ->
              validate == true
         from === nil and to !== nil and value < to ->
              validate == true
         to === nil and from !== nil and value > from ->
              validate == true
         from === nil and to === nil ->
              validate == true
         value <= from ->
              validate == :lesser
         value >= to ->
              validate == :greater
         true ->
              false
       end
  end
end
