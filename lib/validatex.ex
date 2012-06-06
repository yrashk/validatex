defmodule Validatex do

def validate(plan) do
    results = lc {name, value, spec} in plan do
      {name, value, spec, Validatex.Validate.valid?(spec, value)}
    end
    only_errors = fn do
        {_, _, _, true} -> false
        _ -> true
    end
    Enum.filter results, only_errors
end

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

defrecord Format,
          allow_undefined: false,
          allow_nil: false,
          allow_list: false,
          allow_empty: false,
          re: ".*",
          default: ""

defrecord Length,
          is: nil

defrecord Type,
          is: nil

defprotocol Validate do
  @only [Record, Any]
  def valid?(validator, data)
end

defimpl Validate, for: Numericality do
  alias Numericality, as: N
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
  alias Range, as: R
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

defimpl Validate, for: Format do
  alias Format, as: F
  def valid?(F[allow_undefined: false], :undefined), do: :undefined_not_allowed
  def valid?(F[allow_undefined: true, default: default] = v, :undefined), do: valid?(v, default)
  def valid?(F[allow_nil: false], nil), do: :nil_not_allowed
  def valid?(F[allow_nil: true, default: default] = v, nil), do: valid?(v, default)

  def valid?(F[allow_list: false], l) when is_list(l), do: :list_not_allowed
  def valid?(F[allow_list: true] = v, l) when is_list(l), do: valid?(v, iolist_to_binary(l))

  def valid?(F[allow_empty: false], ""), do: :empty_not_allowed
  
  def valid?(F[re: {Regex, _, _, _} = re], s) when is_binary(s) do
      if Regex.match?(re, s), do: true, else: :no_match
  end

  def valid?(F[re: re]=v, s) when is_binary(re) do
      valid?(v.re(%r"#{re}"), s)
  end

  def valid?(F[], _), do: :string_expected
end

defimpl Validate, for: Length do
  alias Length, as: L

  def valid?(L[is: validator], l) when is_list(l) do
      Validatex.Validate.valid?(validator, length(l))
  end

  def valid?(L[is: validator], v) when is_binary(v) or is_tuple(v) do
      Validatex.Validate.valid?(validator, size(v))
  end

  def valid?(L[is: validator], _) do
      Validatex.Validate.valid?(validator)
  end

end

defimpl Validate, for: Type do
    alias Type, as: T
    def valid?(T[ is: :nil], nil), do: true
    def valid?(T[ is: :number ], a) when is_number(a), do: true
    def valid?(T[ is: :integer ], a) when is_integer(a), do: true
    def valid?(T[ is: :float ], a) when is_float(a), do: true
    def valid?(T[ is: :boolean ], a) when is_boolean(a), do: true
    def valid?(T[ is: :atom ], a) when is_atom(a), do: true
    def valid?(T[ is: :binary ], a) when is_binary(a), do: true
    def valid?(T[ is: :string ], a) when is_binary(a), do: true
    def valid?(T[ is: :aliasence ], a) when is_reference(a), do: true
    def valid?(T[ is: :function ], a) when is_function(a), do: true
    def valid?(T[ is: :port ], a) when is_port(a), do: true
    def valid?(T[ is: :pid ], a) when is_pid(a), do: true
    def valid?(T[ is: :tuple ], a) when is_tuple(a), do: true
    def valid?(T[ is: :list ], a) when is_list(a), do: true
    def valid?(T[], _), do: false
end

defimpl Validate, for: Any do
  def valid?(a,a), do: true
  def valid?(a,b) when a > b, do: :lesser
  def valid?(a,b) when b > a, do: :greater
end

end
