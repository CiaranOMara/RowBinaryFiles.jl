module RowBinaryFiles

using BufferedStreams

const Primitive = Union{Nothing,Bool,Int32,Int64,Float64,String,Vector{UInt8}}

# We're just going to use the bsonspec http://bsonspec.org/spec.html, and the work of https://github.com/MikeInnes/BSON.jl.

# Note: the order of the enum is important as the order will define their values/tags. Changing the order will make previoiusly written binary incompatable.

@enum(BinaryType::UInt8,
  eof, double, string, document, array, binary, undefined, objectid, boolean,
  datetime, null, regex, dbpointer, javascript, symbol, javascript_scoped,
  int32, timestamp, int64, decimal128, minkey=0xFF, maxkey=0x7F)

binary_type(::Nothing) = null
binary_type(::Bool) = boolean
binary_type(::Int32) = int32
binary_type(::Int64) = int64
binary_type(::Float64) = double
binary_type(::String) = string
binary_type(::Vector{UInt8}) = binary
binary_type(::BSONDict) = document
binary_type(::BSONArray) = array

binary_primitive(io::IO, ::Nothing) = return
binary_primitive(io::IO, x::Union{Bool,Int32,Int64,Float64}) = write(io, x)
binary_primitive(io::IO, x::Float64) = write(io, x)
binary_primitive(io::IO, x::Vector{UInt8}) = write(io, Int32(length(x)), 0x00, x)
binary_primitive(io::IO, x::String) = write(io, Int32(sizeof(x)+1), x, 0x00)

binary_key(io::IO, k) = write(io, Base.string(k), 0x00)

function binary_pair(io::IO, k, v)
  write(io, binary_type(v))
  binary_key(io, k)
  binary_primitive(io, v)
end

jtype(tag::BinaryType)::DataType =
  tag == null ? Nothing :
  tag == boolean ? Bool :
  tag == int32 ? Int32 :
  tag == int64 ? Int64 :
  tag == double ? Float64 :
  error("Unsupported tag $tag")

function parse_tag(io::IO, tag::BinaryType)
  if tag == null
    nothing
  elseif tag == string
    len = read(io, Int32) - 1
    s = String(read(io, len))
    eof = read(io, 1)
    s
  elseif tag == binary
    len = read(io, Int32)
    subtype = read(io, 1)
    read(io, len)
  else
    read(io, jtype(tag))
  end
end

# Lowering

lower(x::Primitive) = x

# Interface

# binary(io::IO, doc::AbstractDict) = binary_primitive(io, lower_recursive(doc))

# binary(path::String, doc::AbstractDict) = open(io -> binary(io, doc), path, "w")

# binary(path::String; kws...) = binary(path, Dict(kws))


# function stream end
#
# # delegate method call
# for f in (:eof, :flush, :close)
#     @eval function Base.$(f)(io::AbstractFormattedIO)
#         return $(f)(stream(io))
#     end
# end
#
# function Base.open(f::Function, ::Type{T}, args...; kwargs...) where T <: AbstractFormattedIO
#     io = open(T, args...; kwargs...)
#     try
#         f(io)
#     finally
#         close(io)
#     end
# end


include("record.jl")
include("header.jl")
include("reader.jl")
include("writer.jl")





#TODO: save
#TODO: load




end # module
