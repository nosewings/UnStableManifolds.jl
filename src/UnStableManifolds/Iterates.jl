module Iterates

using ..Util: broadcast_size

function iterates(
    f,
    x,
    ;
    make,
    keep = make + 1,
    callback = nothing,
    callback_depth = 0,
    show_iterations = false,
)
    make ≥ 0 || throw(ArgumentError)
    keep ≥ 1 || throw(ArgumentError)
    keep ≤ make + 1 || throw(ArgumentError)

    buffer_size = size(f(x))
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
        @inbounds slices[get_slice_index(i)]
    end

    # Unfortunately, the zeroth iteration is special.
    i = 1
    slices[i] .= x
    x = slices[i]
    @inline function do_callback(i)
        if callback ≠ nothing && i ≥ keep
            deep = tuple(map(get_slice, (i - 1):-1:(i - callback_depth))...)
            # It's simpler to just perform this call with `i - 1` rather than
            # reducing `i` by `1` and changing everything else.
            callback(i - 1, x, deep...)
        end
    end
    do_callback(i)
    i += 1
    # It's a good thing that the index variable in a for-loop is scoped, but I
    # wish we could "remember" it if we wanted to.
    while i ≤ make
        # You can't use `Int`s in an if-expression (good), but you CAN compare
        # `Bool`s to `Int`s and do arithmetic on them???
        if show_iterations ≠ 0 && i % show_iterations == 0
            println(stderr, "iteration ", i)
        end
        slice = get_slice(i)
        slice .= f(x)
        x = slice
        i += 1
    end
    i = get_slice_index(i)
    slices = map(Array, slices)
    cat(slices[i:end]..., slices[1:(i - 1)]..., dims=length(buffer_size))
end

end
