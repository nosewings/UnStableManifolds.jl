using CuArrays: CuArray
using UnStableManifolds.Batch: difference_heatmap_2d
using UnStableManifolds.Maps.CUDA: ricker_2d
import UnStableManifolds.Maps.Ricker2D

let
    xs = collect(0.1:0.1:100.0)
    ys = xs
    xy = [(x, y) for x in xs for y in ys]
    xy = CuArray(reshape(xy, length(xs), length(ys)))
    a = 0.5
    as = CuArray(fill(a, size(xy)...))
    b = 0.5
    bs = CuArray(fill(b, size(xy)...))
    r = 0.8
    rs = CuArray(fill(r, size(xy)...))
    s = 1.2
    ss = CuArray(fill(s, size(xy)...))
    difference_heatmap_2d(
        (x) -> ricker_2d.(x, as, bs, rs, ss),
        xy,
        make = 512,
        show_iterations = 100,
        fixed_point = Ricker2D.coexistence(a, b, r, s),
        plot_x = xs,
        plot_y = ys,
    )
end
