using RowBinaryFiles
using Test

const output = "data.csb"

@testset "RowBinaryFiles" begin


@testset "Writing types" begin
io = open(output, "w")
# RowBinaryFiles.binary_primitive(io::IO, ::Nothing) = return
RowBinaryFiles.binary_primitive(io, 1)
# RowBinaryFiles.binary_primitive(io::IO, x::Float64) = write(io, x)
# RowBinaryFiles.binary_primitive(io::IO, x::Vector{UInt8}) = write(io, Int32(length(x)), 0x00, x)
# RowBinaryFiles.binary_primitive(io::IO, x::String) = write(io, Int32(sizeof(x)+1), x, 0x00)

close(io)
end # testset Writing types


# Test type match in NamedTuple.


# Test column compression.
# Test parsing of compressed columns.

# Test write header.
# Test read header.
# Test update of row_count.

# Test write string.
# Test read string.
# Test parse string.

# Test write number.
# Test read number.
# Test parse number.

# Test expected.
# Test expected increment.
# Test unexpected type.

# Test continuation syntax.

end # testset BinaryFiles
