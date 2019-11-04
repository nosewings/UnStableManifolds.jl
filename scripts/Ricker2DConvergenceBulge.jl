using CuArrays: CuArray
using UnStableManifolds.Batch: difference_heatmap_2d
using UnStableManifolds.Maps.CUDA: ricker_2d
import UnStableManifolds.Maps.Ricker2D

let
    xs = collect(1.0:0.1:100.0)
    ys = xs
    xy = [(x, y) for x in xs for y in ys]
    xy = reshape(xy, length(xs), length(ys))
    a = 0.5
    as = fill(a, size(xy)...)
    b = 0.5
    bs = fill(b, size(xy)...)
    r = 2.05
    rs = fill(r, size(xy)...)
    s = 1.75
    ss = fill(s, size(xy)...)
    difference_heatmap_2d(
        ricker_2d,
        xy,
        as,
        bs,
        rs,
        ss,
        make = 500,
        show_iterations = 100,
        convert_to_before = CuArray,
        convert_to_after = Array,
        fixed_point = Ricker2D.coexistence(a, b, r, s),
        plot_x = xs,
        plot_y = ys,
    )
end
