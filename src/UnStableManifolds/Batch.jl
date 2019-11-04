module Batch

using LinearAlgebra: norm
using Plots: pyplot, plot, scatter!, heatmap!
using ..Iterates: iterates
using ..FindDoublingCycles: find_doubling_cycles

function bifurcation_plot_2d(
    f,
    x,
    args...,
    ;
    make,
    show_iterations = false,
    convert_to_before = nothing,
    convert_to_after = nothing,
    colors,
    plt = nothing,
    plot_x,
    plot_y,
)
    max_exp = length(colors) - 1
    max_power = 2^max_exp
    keep = max_power + 1

    if convert_to_before ≠ nothing
        x = convert(convert_to_before, x)
        args = [convert_to_before(arg) for arg in args]
    end
    result = iterates(
        f,
        x,
        args...,
        make = make,
        keep = keep,
        show_iterations = show_iterations,
    )
    if convert_to_after ≠ nothing
        result = convert(convert_to_after, result)
    end
    cycles = find_doubling_cycles(result, max_exp)

    if plt == nothing
        pyplot()
        plt = plot(axis_ratio = 1, size = (900, 900))
    end
    for i in 0:max_exp
        j = 2^i
        ixs = findall(x -> x == j, cycles)
        xs = [plot_x[ix] for ix in ixs]
        ys = [plot_y[ix] for ix in ixs]
        scatter!(plt, xs, ys, color = colors[i + 1], markerstrokewidth=0)
    end
    plt
end

function difference_heatmap_2d(
    f,
    x,
    args...,
    ;
    make,
    show_iterations = false,
    convert_to_before = nothing,
    convert_to_after = nothing,
    fixed_point,
    plt = nothing,
    plot_x,
    plot_y,
)
    if convert_to_before ≠ nothing
        x = convert(convert_to_before, x)
        args = [convert_to_before(arg) for arg in args]
    end
    result = iterates(
        f,
        x,
        args...,
        make = make,
        keep = 1,
        show_iterations = show_iterations,
    )
    # The last dimension will be trivial, so drop it.
    result = dropdims(result, dims = ndims(result))
    if convert_to_after ≠ nothing
        result = convert(convert_to_after, result)
    end
    norms = norm.(result .- [fixed_point])

    if plt == nothing
        pyplot()
        plt = plot(axis_ratio = 1, size = (900, 900))
    end
    heatmap!(plot_x, plot_y, norms)
    plt
end

end
