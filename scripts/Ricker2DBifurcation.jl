using Strided: StridedView
using BigMacro: @bigfloat
using UnStableManifolds: iterates
using UnStableManifolds.Maps: ricker_2d

function ricker_2d_bifurcate(xy, a, b, r, s, n)
    result = iterates(ricker_2d, xy, a, b, r, s, make=n, keep=1, show_iterations=10)
end

@bigfloat 128 begin
    r = StridedView(collect("0.0":"0.0001":"3.5"))
    s = StridedView(collect("0.0":"0.0001":"3.5"))
    xy = StridedView(fill(("0.1", "0.5"), size(r)...))
    a = StridedView(fill("0.5", size(r)...))
    b = StridedView(fill("0.5", size(r)...))
end
n = 2001

result = ricker_2d_bifurcate(xy, a, b, r, s, n)
