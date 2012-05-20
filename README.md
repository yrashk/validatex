Validatex
==========

Validaterl is a simple Elixir library for validating (input) data. Its
design and code has been almost completely ported from Validaterl (https://github.com/spawngrid/validaterl)

Validation Primitives
---------------------

Using records defined in Validatex one can check individual values against
validators.

For example:

```elixir
iex> refer Validatex, as: V
[]
iex> V.Validate.valid?(V.Range.new(to: 10), 1)
true
iex> V.Validate.valid?(V.Range.new(to: 0), 1) 
:greater
````

Also, if the second argument is not a validator, it will be matched against the first argument:

```elixir
iex> V.Validate.valid?(1,1)                  
true
iex> V.Validate.valid?(2,1)
:lesser
iex> V.Validate.valid?(0, 1)
:greater
```

Custom Validators
-----------------

One can define custom validators using by implementing `Validatex.Validate` protocol

```elixir
  defrecord MyValidator, q: nil

  defimpl Validatex.Validate, for: MyValidator do
     refer MyValidator, as: V
     def valid?(V[], v), do: v
  end
```


Validation Sheets
-----------------

Instead of running individual validations, you can define so called "validation sheets" and test them using
`Validatex.validate`.

Validation sheet is a list of validations in the following format:

```elixir
{name, value, spec}
```

For example:

```elixir
[
 {"user.name", username, V.Length.new(is: V.Range.new(from: 3, to: 16))},
 {"user.email", email, V.Length.new(is: V.Range.new(from: 3, to: 255))},
 {"user.age", age, V.Numericality.new(allow_string: true)}
]
```

Just as an example, if you try to put a string with a non-numeric value into `age`, you'll get this:

```erlang
iex> V.validate(plan)
[{"user.age","wrong",Validatex.Numericality[default: 0],:number_expected}]
```