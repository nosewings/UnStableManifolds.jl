module FindDoublingCycles

function find_doubling_cycles(data, max_exp, (≈) = (≈))
    data_size = size(data)
    data_ndims = ndims(data)
    data_length = data_size[data_ndims]
    2^max_exp + 1 ≤ data_length || throw(ArgumentError)
    # Compare everything to the last slice.
    base = selectdim(data, data_ndims, data_length)
    ret = zeros(Int, data_size[1:(end - 1)])
    for i in (2^x for x in 0:max_exp)
        j = data_length - i
        slice = selectdim(data, data_ndims, j)
        (@view ret[(slice .≈ base) .& (ret .== 0)]) .= i
    end
    ret
end

end
