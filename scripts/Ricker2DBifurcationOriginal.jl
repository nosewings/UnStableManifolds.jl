using CuArrays: CuArray
using UnStableManifolds.Batch: bifurcation_plot_2d
using UnStableManifolds.Maps.CUDA: ricker_2d

let
    r = collect(0.0001:0.005:3.0)
    r = reshape([i for i in r for j in r], length(r), length(r))
    s = copy(r')
    x = fill((0.1, 0.5), size(r)...)
    a = fill(0.5, size(r)...)
    b = a
    colors = [
        "black",
        "blue",
        "green",
        "red",
        "magenta",
        "yellow",
        "brown",
    ]

    bifurcation_plot_2d(
        ricker_2d,
        x,
        a,
        b,
        r,
        s,
        make = 2000,
        show_iterations = 100,
        convert_to_before = CuArray,
        convert_to_after = Array,
        colors = colors,
        plot_x = r,
        plot_y = s,
    )
end
