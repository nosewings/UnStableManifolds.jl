using CuArrays: CuArray
using UnStableManifolds.Batch: bifurcation_plot_2d
using UnStableManifolds.Maps.CUDA: ricker_2d

let
    r = collect(0.0001:0.005:3.0)
    r = reshape([i for i in r for j in r], length(r), length(r))
    s = r'
    rs = CuArray(r)
    ss = CuArray(s)
    xy = CuArray([(0.1, 0.5)])
    as = CuArray([0.5])
    bs = as
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
        (x) -> ricker_2d.(x, as, bs, rs, ss),
        xy,
        make = 2000,
        show_iterations = 100,
        colors = colors,
        plot_x = r,
        plot_y = s,
    )
end
