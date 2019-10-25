module UnStableManifolds


id(x...) :: Tuple = x


function broadcast_size(arrays...) :: Tuple
    broadcasted = id.(arrays...)
    broadcasted isa Tuple ? (1,) : size(broadcasted)
end


function iterates(
    f :: Function,
    x :: AbstractArray,
    args...,
    ;
    make :: Int = throw(ArgumentError),
    keep :: Union{Int, Nothing} = nothing,
    callback :: Union{Function, Nothing} = nothing,
    callback_depth :: Int = 0,
) :: Array
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

    # It's a good thing that the index variable in a for-loop is scoped, but I
    # wish we could "remember" it if we wanted to.
    i = 1 
    slices[1] .= x
    x = slices[1]
    while i <= make
        i += 1
        slice = get_slice(i)
        slice .= f.(x, args...)
        x = slice
        if callback != nothing
            deep = tuple(map(get_slice, i-1:-1:i-(callback_depth+1))...)
            callback(x, deep)
        end
    end
    i = get_slice_index(i)
    cat(slices[i+1:end]..., slices[1:i]..., dims=length(buffer_size))
end


# If we had higher-kinded types (and some more powerful static type expressions;
# e.g., "strict subtype" or "is not abstract"), we could say "all of these
# values need to be a subtype of a common concrete array type." Alas, we cannot.
#
# If we had a nontrivial least upper bound operator on types, we could at least
# enforce that invariant dynamically. Alas, we cannot.
#
# So the only option is the lame one: just default to Array if x isn't an array.
#
# Why even bother with PLT if no one ever listens?
function iterates(f :: Function, x, args...; kwargs...) :: Array
    iterates(f, [x], args...; kwargs...)
end        


function ricker_2d(
    (x, y) :: Tuple{T, T},
    a :: T,
    b :: T,
    r :: T,
    s :: T,
) :: Tuple{T, T} where {T <: Real}
    x*exp(r - x - a*y), y*exp(s - y - b*x)
end

end
