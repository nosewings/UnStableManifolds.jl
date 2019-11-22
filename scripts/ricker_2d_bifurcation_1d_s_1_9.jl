using CuArrays: CuArray
using UnStableManifolds.Batch: bifurcation_plot_2d_in_1d
using UnStableManifolds.Maps.CUDA: ricker_2d

let
    r = collect(0.0:0.001:4)
    s = [1.9]

    xy = CuArray([(0.1, 0.5)])
    rs = CuArray(r)
    ss = CuArray(s)
    as = CuArray([0.5])
    bs = as

    bifurcation_plot_2d_in_1d(
        (x) -> ricker_2d.(x, as, bs, rs, ss),
        xy,
        make = 4096,
        keep = 128,
        show_iterations = 100,
        plot_x = r,
    )
end
