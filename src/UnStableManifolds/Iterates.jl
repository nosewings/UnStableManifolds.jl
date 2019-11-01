module Iterates

using ..Util: broadcast_size

function iterates(
    f,
    x :: AbstractArray,
    args...,
    ;
    make,
    keep = make + 1,
    callback = nothing,
    callback_depth = 0,
    show_iterations = false,
)
    make >= 0 || throw(ArgumentError)
    keep >= 1 || throw(ArgumentError)
    keep <= make + 1 || throw(ArgumentError)

    buffer_size = broadcast_size(x, args...)
    buffer_size = (buffer_size..., keep)
    buffer = similar(x, buffer_size)

    # TODO:
    # We should use a dedicated ring buffer type. At the moment, I can't be
    # bothered to implement it properly.
    slices = collect(eachslice(buffer, dims=length(buffer_size)))
    length_slices = length(slices)
    @inline function get_slice_index(i)
        mod(i - 1, length_slices) + 1
    end
    @inline function get_slice(i)
        slices[get_slice_index(i)]
    end

    # Unfortunately, the zeroth iteration is special.
    i = 1
    slices[i] .= x
    x = slices[i]
    @inline function do_callback(i)
        if callback ≠ nothing && i ≥ keep
            deep = tuple(map(get_slice, (i - 1):-1:(i - callback_depth))...)
            # It's simpler to just perform this call with i - 1 rather than
            # reducing i by 1 and changing everything else.
            callback(i - 1, x, deep...)
        end
    end
    do_callback(i)
    i += 1
    # It's a good thing that the index variable in a for-loop is scoped, but I
    # wish we could "remember" it if we wanted to.
    while i ≤ make
        # You can't use Ints in an if-expression (good), but you CAN compare
        # Bools to Ints and do arithmetic on them???
        if show_iterations ≠ 0 && (i - 1) % show_iterations == 0
            @show i
        end
        slice = get_slice(i)
        slice .= f.(x, args...)
        x = slice
        do_callback(i)
        i += 1
    end
    i = get_slice_index(i)
    cat(slices[(i + 1):end]..., slices[1:i]..., dims=length(buffer_size))
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
function iterates(f, x, args...; kwargs...)
    iterates(f, [x], args...; kwargs...)
end

end
