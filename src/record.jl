# Record
# ==========

struct Record{NT <: NamedTuple}
    row::NT
    Record(row::NT) where {NT} = new{NT}(row)
end
