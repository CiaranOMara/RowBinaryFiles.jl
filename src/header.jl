# Header
# ==========

const MAGIC = 0x726f772062696e6172792066696c65 # row binary file (15 bytes).

typeof(MAGIC)

const ROW_BINARY_FILE_VERSION = "0.1.0" #TODO: would be nice to retrieve this from the Project.toml.

typeof(ROW_BINARY_FILE_VERSION)


struct Header
    magic::UInt128 #Static.
    version::String #Static.
    data_offset::UInt64 #Calulated.
    row_count::UInt64 #Provided or modifed post hoc.
    column_count::UInt64 #Provided or modifed post hoc.
    column_definitions::NamedTuple #Provided.

    function Header(columns::NamedTuple, row_count)

        compressed_column_deffinitions

        compressed_column_deffinitions_size = sizeof(compressed_column_deffinitions)

        # data_offset = magic + version + data_offset + row_count + compressed_column_deffinitions_size + column_definitions
        data_offset = sizeof(UInt16) + sizeof(UInt16) + sizeof(UInt64) + sizeof(UInt64) + compressed_column_deffinitions_size

        return new(
            MAGIC,
            VERSION,
            data_offset,
            row_count,
            column_count,
            column_definition_size,
        )
    end

end

data_offset = sizeof(UInt16) + sizeof(UInt16) + sizeof(UInt64) + sizeof(UInt64)


sizeof(UInt8)
sizeof(UInt16)
sizeof(UInt32)
sizeof(UInt64)

sizeof(MAGIC)
sizeof(VERSION)


struct ColumnDefinition
    name::String
    type::DataType
end

function generate_row_type(definitions::Vector{ColumnDefinition}) where {NT}

    s = getfield.(definitions, :name)
    t = getfield.(definitions, :type)

    return NamedTuple{(s...,), Tuple{t...}}
end

function Base.read(io::IO, ::Type{Header})

    seekstart(io)

    magic = read(io, UInt16)
    version = read(io, UInt16)
    data_offset = read(io, UInt64)
    row_count = read(io, UInt16)
    column_definition_size = read(io, UInt64)

    pos = position(io)

    stop = pos + column_definition_size + 1 # dunno if the plus one is required.

    column_definitions = read(io, Vector{Column}) # from pos to pos + column_definition_size



    return Header(
        magic,
        version,
        data_offset,
        row_count,
        column_definition_size,
        column_definitions)
end

function Base.write(stream::IO, header::Header)

    return write(
        stream,
        header.magic,
        header.version,
        header.data_offset,
        header.row_count,
        header.column_definition_size,
        header.column_definitions)
end
