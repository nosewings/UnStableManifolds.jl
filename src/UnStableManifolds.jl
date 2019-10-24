module UnStableManifolds

id(x...) :: Tuple = x

function broadcast_size(arrays...) :: Tuple
    broadcasted = id.(arrays...)
    if isa(broadcasted, Tuple)
        (1,)
    else
        size(broadcasted)
    end
end

function iterates(
    f :: Function,
    x,
    args...,
    ;
    make :: Int = throw(ArgumentError),
    keep :: Union{Int, Nothing} = nothing,
    callback :: Union{Function, Nothing} = nothing,
    callback_depth :: Int = 0,
)
    if make < 0
        throw(ArgumentError)
    end

    if keep == nothing
        keep = make + 1
    elseif keep < 1 || make <= keep
        throw(ArgumentError)
    end

    buffer_size = broadcast_size(x, args...)
    buffer_size = (buffer_size..., keep)
    buffer = similar(x, buffer_size)

    # TODO
    # We should use a dedicated ring buffer type. At the moment, I can't be
    # bothered to implement it properly in a language that allows ARBITRARY
    # INDEXING STYLES.
    slices = collect(eachslice(buffer, dims=length(buffer_size)))
    function get_slice_index(i)
        mod(i - 1, length(slices)) + 1
    end
    function get_slice(i)
        slices[get_slice_index(i)]
    end

    i = 1
    slices[1] .= x
    x = slices[1]
    while i <= make
        i += 1
        slice = get_slice(i)
        slice .= f.(x, args...)
        x = slice
        if callback != nothing
            deep = tuple(map(get_slice, i-1 : -1 : i-(callback_depth+1))...)
            callback(x, deep)
        end
    end
    i = get_slice_index(i)
    cat(slices[i:end]..., slices[1:i-1]..., dims=length(buffer_size))
end

# WHAT
# BULLSHIT
# IS
# THIS
(ricker_2d(
    (x, y) :: Tuple{T, T},
    a :: T,
    b :: T,
    r :: T,
    s :: T,
) :: Tuple{T, T}) where {T <: Real} =
    x*exp(r - x - a*y), y*exp(s - y - b*x)

end
