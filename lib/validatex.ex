defmodule Validatex do

defrecord Numericality, 
          allow_undefined: false,
          allow_nil: false,
          allow_list: false,
          allow_string: false,
          allow_empty: false,
          allow_rest: false,
          allow_float: true,
          default: 0

defrecord Range,
          from: nil,
          to: nil,
          exclusive: false

defprotocol Validate do
  def valid?(validator, data)
end

defimpl Validate, for: Numericality do
  refer Numericality, as: N
  def valid?(N[ allow_undefined: false ], :undefined), do: :undefined_not_allowed
  def valid?(N[ allow_undefined: true, default: default ] = v, :undefined), do: valid?(v, default)

  def valid?(N[ allow_nil: false ], nil), do: :nil_not_allowed
  def valid?(N[ allow_nil: true, default: default ] = v, nil), do: valid?(v, default)

  def valid?(N[ allow_list: false], l) when is_list(l), do: :list_not_allowed
  def valid?(N[ allow_list: true] = v, l) when is_list(l), do: valid?(v, iolist_to_binary(l))

  def valid?(N[ allow_string: true, allow_empty: false], ""), do: :empty_not_allowed
  def valid?(N[ allow_string: true, allow_empty: true, default: default] = v,  ""), do: valid?(v, default)     
  def valid?(N[ allow_string: false ], s) when is_binary(s), do: :string_not_allowed
  def valid?(N[ allow_string: true, allow_rest: rest ] = v, s) when is_binary(s) do
      str = binary_to_list(s)
      case :string.to_integer(str) do
          {:error, :no_integer} ->
            :number_expected
          {value, []} ->
            valid?(v, value)
          {value, _} ->
            case :string.to_float(str) do
              {:error, _} ->
                if rest, do: valid?(v, value), else: :rest_not_allowed
              {value_f, []} ->
                valid?(v, value_f)
              {value_f, _} ->
                if rest, do: valid?(v, value_f), else: :rest_not_allowed
            end
     end          
  end
  
  def valid?(N[ allow_float: false ], f) when is_float(f), do: :float_not_allowed
  def valid?(N[], v) when is_number(v), do: true
  def valid?(N[], _), do: :number_expected

end

defimpl Validate, for: Range do
  refer Range, as: R
  def valid?(R[from: nil, to: nil], _), do: true
  def valid?(R[from: from, to: nil, exclusive: false], v) when from !== nil and v < from, do: :lesser
  def valid?(R[from: from, to: nil, exclusive: true], v) when from !== nil and v <= from, do: :lesser
  def valid?(R[from: nil, to: to, exclusive: false], v) when to !== nil and v > to, do: :greater
  def valid?(R[from: nil, to: to, exclusive: true], v) when to !== nil and v >= to, do: :greater
  def valid?(R[to: to, exclusive: false], v) when to !== nil and v > to, do: :greater
  def valid?(R[from: from, exclusive: false], v) when from !== nil and v < from, do: :lesser
  def valid?(R[from: from, exclusive: true], v) when from !== nil and v <= from, do: :lesser
  def valid?(R[to: to, exclusive: false], v) when to !== nil and v > to, do: :greater
  def valid?(R[to: to, exclusive: true], v) when to !== nil and v >= to, do: :greater
  def valid?(R[], _), do: true

end

end
