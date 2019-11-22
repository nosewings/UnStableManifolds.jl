module Batch

using LinearAlgebra: norm
using Plots: pyplot, plot, scatter, scatter!, heatmap!
using ..Iterates: iterates
using ..FindDoublingCycles: find_doubling_cycles

function bifurcation_plot_2d_in_1d(
    f,
    x,
    ;
    make,
    keep = make + 1,
    show_iterations = false,
    plot_x,
)
    result = iterates(
        f,
        x,
        make = make,
        keep = keep,
        show_iterations = show_iterations,
    )
    pyplot()
    plot_args = [
        :legend => false,
        :color => :black,
        :markersize => 1,
        :markeralpha => 0.5,
        :markerstrokewidth => 0,
    ]
    p1 = scatter(
        plot_x,
        getindex.(result, 1),
        ;
        plot_args...,
        title = "x",
    )
    p2 = scatter(
        plot_x,
        getindex.(result, 2),
        ;
        plot_args...,
        title = "y",
    )
    p3 = scatter(
        plot_x,
        norm.(result),
        ;
        plot_args...,
        title = "norms",
    )
    plot(p1, p2, p3; layout = (1, 3), size = (1280, 960), link = :y)
end

function bifurcation_plot_2d(
    f,
    x,
    ;
    make,
    show_iterations = false,
    colors,
    plt = nothing,
    plot_x,
    plot_y,
)
    max_exp = length(colors) - 1
    max_power = 2^max_exp
    keep = max_power + 1

    result = iterates(
        f,
        x,
        make = make,
        keep = keep,
        show_iterations = show_iterations,
    )
    cycles = find_doubling_cycles(result, max_exp)

    if plt == nothing
        pyplot()
        plt = plot(axis_ratio = 1, size = (900, 900))
    end
    for i in max_exp:-1:0
        j = 2^i
        ixs = findall(x -> x == j, cycles)
        xs = [plot_x[ix] for ix in ixs]
        ys = [plot_y[ix] for ix in ixs]
        scatter!(
            plt,
            xs,
            ys,
            color = colors[i + 1],
            markersize = 2,
            minorgrid = true,
            minorticks = 0.1,
            markerstrokewidth = 0,
            legend = false
        )
    end
     plt
end

function difference_heatmap_2d(
    f,
    x,
    ;
    make,
    show_iterations = false,
    fixed_point,
    plt = nothing,
    plot_x,
    plot_y,
)
    result = iterates(
        f,
        x,
        make = make,
        keep = 1,
        show_iterations = show_iterations,
    )
    # The last dimension will be trivial, so drop it.
    result = dropdims(result, dims = ndims(result))
    norms = norm.(result .- [fixed_point])

    if plt == nothing
        pyplot()
        plt = plot(axis_ratio = 1, size = (900, 900))
    end
    heatmap!(plot_x, plot_y, norms)
    plt
end

end
