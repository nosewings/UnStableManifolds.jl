module UnStableManifolds

include("util.jl")
include("maps.jl")

export logistic, ricker_2d, ricker_2d_cuda

using CUDAnative


@inline function tuple_norm_cuda((x, y) :: Tuple)
    CUDAnative.sqrt(x^2 + y^2)
end


function tuple_isapprox_cuda(
    (x1, y1) :: Tuple,
    (x2, y2) :: Tuple,
)
    x = (x1 - x2)^2
    y = (y1 - y2)^2
    CUDAnative.sqrt(x^2 + y^2) < 1e-10
end


function tuple_isapprox(
    (x1, y1) :: Tuple,
    (x2, y2) :: Tuple,
)
    x = (x1 - x2)^2
    y = (y1 - y2)^2
    sqrt(x^2 + y^2) < 1e-10
end


function iterates(
    f :: Function,
    x :: AbstractArray{T},
    args...,
    ;
    make :: Int,
    keep :: Union{Int, Nothing} = nothing,
    callback :: Union{Function, Nothing} = nothing,
    callback_depth :: Int = 0,
    show_iterations :: Bool = false,
) :: Array{T} where {T}
    if make < 0
        throw(ArgumentError)
    end
    if keep == nothing
        keep = make + 1
    elseif keep < 1 || make <= keep
        throw(ArgumentError)
    end

    buffer_size :: Tuple = broadcast_size(x, args...)
    buffer_size = (buffer_size..., keep)
    buffer :: AbstractArray{T} = similar(x, buffer_size)

    # TODO:
    # We should use a dedicated ring buffer type. At the moment, I can't be
    # bothered to implement it properly in a language that allows ARBITRARY
    # INDEXING STYLES.
    slices = collect(eachslice(buffer, dims=length(buffer_size)))
    length_slices :: Int = length(slices)
    # Make these inner functions inline to avoid allocations.
    @inline function get_slice_index(i)
        mod(i - 1, length_slices) + 1
    end
    @inline function get_slice(i)
        slices[get_slice_index(i)]
    end

    # Unfortunately, the first iteration is special.
    i :: Int = 1
    slices[i] .= x
    x = slices[i]
    @inline function do_callback(i)
        if callback != nothing && i >= keep
            deep = tuple(map(get_slice, i-1:-1:i-callback_depth)...)
            # It's simpler to just perform this call with i-1 rather than
            # reducing i by 1 and changing everything else.
            callback(i-1, x, deep...)
        end
    end
    do_callback(i)
    i += 1
    # It's a good thing that the index variable in a for-loop is scoped, but I
    # wish we could "remember" it if we wanted to.
    while i <= make
        if show_iterations
            @show i
        end
        slice = get_slice(i)
        slice .= f.(x, args...)
        x = slice
        do_callback(i)
        i += 1
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
# So the only option is the lame one: just default to Array if x isn't an
# AbstractArray.
#
# Why even bother with PLT?
function iterates(f :: Function, x, args...; kwargs...) :: Array
    iterates(f, [x], args...; kwargs...)
end


function convergence(
    f :: Function,
    x :: AbstractArray{T},
    args...,
    ;
    make :: Int,
    approx :: Function,
) :: Array{Int} where {T}
    ret_size = broadcast_size(x, args...)
    ret :: AbstractArray{Int} = similar(x, Int, ret_size)
    fill!(ret, 0)
    function callback_kernel(orig :: Int, i :: Int, x1 :: T, x0 :: T) :: Int
        if orig != 0
            return orig
        end
        approx(x1, x0) ? i : 0
    end
    function callback(i :: Int, x1, x0)
        ret .= callback_kernel.(ret, i, x1, x0)
    end
    iterates(
        f,
        x,
        args...,
        make=make,
        keep=2,
        callback=callback,
        callback_depth=1,
    )
    ret
end


# Do the lame thing.
function convergence(f :: Function, x, args...; kwargs...)
    convergence(f, [x], args...; kwargs...)
end


end
