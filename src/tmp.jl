
using Serialization

output = "data.csb"


io = open(output, "w")

write(io, binary_type(Bool))

x = "hello"
write(io, Int32(sizeof(x) + 1), x, 0x00)

write(io, 2)
write(io, 2.0)

named = (a = 1, b = 2, c = 3.)

length(named)
sizeof(named)
write(io, named)
write(io, Tuple{Int64, Int64, Float64})
write(io, Int64)

serialize(io, named)

values(named)
keys(named)
typeof(named)
first(named)
last(named)

collect(named)

types(named)
type(named)
type(named)

collect(pairs(named))
collect(types(named))

mytupletype = NamedTuple{(:a, :b, :c),Tuple{Int64, Int64, Int64}}

isa(named, mytupletype)

n = String["a", "b", "c"]
s = Symbol.(n)
t = DataType[Int64, Int64, Float64]

t = (1,2,3)

typeof(t)

test = Tuple{s...}
test = Tuple{t...}
test = NamedTuple{(s...), Tuple{t...}}
test = NamedTuple{(:a, :b, :c), Tuple{t...}}
ts = (:a, :b, :c)
ts = (s...)
typeof(ts)
# ts = {:a, :b, :c}
test = NamedTuple{ts, Tuple{t...}}
test = NamedTuple{ts, Tuple{t...}}

macro generate_named_typle_type(s, t)
  return :(NamedTuple{((esc.(s)...)), Tuple{(esc.(t)...)}})
end

@generate_named_typle_type(s,t)

macro tmp(arg1, arg2)

  # asd = ($(esc.(arg1)...),)
  # ($(esc.(ks)...),)

  :(NamedTuple{($arg1...,), Tuple{$arg2...}})
end
@tmp(s, t)

(esc.(s))

result = NamedTuple{(s...,), Tuple{t...}}

result.a

# @assert all(k -> k isa Symbol, ks)
# ss = Expr.(:quote, ks)
ss = join(string.(s), ", ")
ts = join(string.(t), ", ")
# @tmp(:a)

for v in s
  join(["apples", "bananas", "pineapples"], ", ", " and ")
end



macro deftype(name)
  esc(:(struct $name end))
end

@deftype foo

foo()

join(string.(s), ", ")

generated = @generate_named_typle_type(s, t)

named.
NamedTuple.types
fieldnames(named)

write(io, Float64)

close(io)

named.a = 6


@enum Fruit apple=1 orange=2 kiwi=3

f(x::Fruit) = "I'm a Fruit with value: $(Int(x))"

f(apple)
f(orange)

Fruit(1)


@enum(BinaryType::UInt8,
  eof, double, string, binary, undefined, boolean, null, symbol,
  int32, int64, decimal128, minkey = 0xFF, maxkey = 0x7F)
