using CuArrays: CuArray
using UnStableManifolds.Batch: bifurcation_plot_2d
using UnStableManifolds.Maps: logistic_2d

let
    a = collect(1.0:0.005:4.0)
    a = reshape([i for i in a for j in a], length(a), length(a))
    b = a'
    as = CuArray(a)
    bs = CuArray(b)
    xy = CuArray([(0.5, 0.5)])
    cs = CuArray([0.25])
    ds = cs
    colors = [
        "black",
        "blue",
        "green",
        "red",
        "magenta",
    ]
    bifurcation_plot_2d(
        (x) -> logistic_2d.(x, as, bs, cs, ds),
        xy,
        make = 2048,
        show_iterations = 100,
        colors = colors,
        plot_x = a,
        plot_y = b,
    )
end
