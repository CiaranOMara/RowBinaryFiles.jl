# Reader
# ==========

# # A type keeping track of a ragel-based parser's state.
# mutable struct State{T<:BufferedInputStream}
#     stream::T      # input stream
#     cs::Int        # current DFA state of Ragel
#     linenum::Int   # line number: parser is responsible for updating this
#     finished::Bool # true if finished (regardless of where in the stream we are)
# end
#
# function State(initstate::Int, input::BufferedInputStream)
#     return State(input, initstate, 1, false)
# end

mutable struct Reader
    # state::BioCore.Ragel.State
    stream::BufferedInputStream
    expected::Int
    column_types::Vector{DataType} #TODO: use full vector column or named tuple format?

    function Reader(input::IO, column_types::Vector{DataType})
        return new(BufferedStreams.BufferedInputStream(input), 1, column_types)
    end
end

# function Reader(input::IO; index = nothing) # index is associated with Tabix Indexes. Won't need this.
#     if isa(index, AbstractString)
#         index = Index(index)
#     else
#         if index != nothing
#             throw(ArgumentError("index must be a filepath or nothing"))
#         end
#     end
#     return Reader(BufferedStreams.BufferedInputStream(input), index)
# end

function Base.eltype(::Type{Reader})
    return Record
end

function Base.read(input::Reader)
    return read!(input, eltype(input)())
end

function tryread!(reader::Reader, output)
    try
        read!(reader, output)
        return output
    catch ex
        if isa(ex, EOFError)
            return nothing
        end
        rethrow()
    end
end

function Base.IteratorSize(::Reader)
    #TODO: return row count from header.
end

# next = iterate(iter)
# while next !== nothing
#     (i, state) = next
#     # body
#     next = iterate(iter, state)
# end

# struct Squares
#            count::Int
#        end

# Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)

# Base.eltype(::Type{Squares}) = Int # Note that this is defined for the type

# Base.length(S::Squares) = S.count

# Base.iterate(rS::Iterators.Reverse{Squares}, state=rS.itr.count) = state < 1 ? nothing : (state*state, state-1)

# function Base.getindex(S::Squares, i::Int)
#     1 <= i <= S.count || throw(BoundsError(S, i))
#     return i*i
# end

# Base.firstindex(S::Squares) = 1
# Base.lastindex(S::Squares) = length(S)
# Base.getindex(S::Squares, i::Number) = S[convert(Int, i)]
# Base.getindex(S::Squares, I) = [S[i] for i in I]


#TODO: strided if types are fixed in size.

function Base.iterate(reader::Reader, state = eltype(reader)())
    if tryread!(reader, nextone) === nothing
        return nothing
    else
        return copy(nextone), nextone
    end
end

function Base.getindex(reader::Reader, name::AbstractString) #TODO: convert to read column.
    if reader.index == nothing
        throw(ArgumentError("no index attached"))
    end
    seekrecord(reader.state.stream, reader.index, name)
    reader.state.cs = file_machine.start_state
    reader.state.finished = false
    return read(reader)
end



# # print all numbers literals from a stream
# stream = BufferedInputStream(source)
# while !eof(stream)
#     b = peek(stream)
#     if '1' <= b <= '9'
#         if !isanchored(stream)
#             anchor!(stream)
#         end
#     elseif isanchored(stream)
#         println(ASCIIString(takeanchored!(stream)))
#     end
#     read(stream, UInt8)
# end
