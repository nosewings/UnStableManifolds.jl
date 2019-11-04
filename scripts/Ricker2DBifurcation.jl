using Strided: StridedView
using UnStableManifolds.Batch: bifurcation_plot_2d
using UnStableManifolds.Maps: ricker_2d
using DoubleFloats

let
    r = collect(DoubleFloat(0.0):DoubleFloat(0.001):DoubleFloat(3.0))
    r = StridedView(reshape([i for i in r for j in r], length(r), length(r)))
    s = copy(r')
    x = StridedView(fill((DoubleFloat(0.1), DoubleFloat(0.5)), size(r)...))
    a = StridedView(fill(DoubleFloat(0.5), size(r)...))
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
        colors = colors,
        plot_x = r,
        plot_y = s,
    )
end
