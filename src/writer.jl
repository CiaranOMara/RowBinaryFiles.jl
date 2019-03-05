# Writer
# ==========

# Use UInt32 for left and right positions.


mutable struct WriterState

    # State
    started::Bool
    # buffer::IOBuffer
    compressed::Vector{UInt8}
    # intervals::Vector{Interval{Nothing}}

    # Cell buffer.
    # cellbuffer::IOBuffer

    function WriterState()
        return new(
            # State
            false, IOBuffer(), UInt8[], Interval{Nothing}[],
            # record buffer
            IOBuffer(),
            # global info
            BBI.Block[], 0, 0,
            0, +Inf32, -Inf32, 0.0f0, 0.0f0)
    end
end


struct Writer
    # output stream
    stream::IO
    # maximum sequence width (no limit when width ≤ 0)
    columns::NamedTuple

    expected::Int

        # # maximum size of uncompressed buffer
        # max_buffer_size::UInt64
        #
        # # file offsets
        # data_offset::UInt64
        #
        # # mutable state
        # state::WriterState

end

function expected(writer::Writer)
    return writer.columns[writer.expected]
end

function Writer(stream::IO; column_types::NamedTuple)
    return Writer(stream, column_types)
end


function Base.write(writer::Writer, cell)

    # Check if cell is of the expected type.

    # Write cell

    # Increment expected type and / or row count.

    return pos
end

function Base.open(::Type{Writer}, filepath::AbstractString, args...; kwargs_...)
    kwargs = collect(kwargs_)
    i = findfirst(kwarg -> kwarg[1] == :append, kwargs)
    if i !== nothing
        append = kwargs[i][2]
        if !isa(append, Bool)
            throw(ArgumentError("append must be boolean"))
        end
        deleteat!(kwargs, i)
    else
        append = false
    end
    return T(open(filepath, append ? "a" : "w"), args...; kwargs...)
end

# function Base.close(writer::Writer)
#
#     state = writer.state
#
#     if state.started
#         finish_section!(writer)
#     end
#
#     close(stream)
#
#     return
# end

# stream = BufferedOutputStream(open(filename, "w")) # wrap an IOStream
#
# out = BufferedOutputStream()
# print(out, "Hello")
# print(out, " World")
# str = String(take!(out))
