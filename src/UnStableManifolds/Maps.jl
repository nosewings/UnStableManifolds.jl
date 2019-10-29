module Maps

using Requires

export logistic, ricker_2d

logistic(x, r) =
    r*x*(1 - x)

ricker_2d((x, y), a, b, r, s) =
    x*exp(r - x - a*y), y*exp(s - y - b*x)

@require CUDAnative="be33ccc6-a3ff-5ff2-a52e-74243cff1e17" include("Maps/CUDA.jl")

end
