module Maps

include("Maps/CUDA.jl")

logistic(x, r) =
    r*x*(1 - x)

ricker_2d((x, y), a, b, r, s) =
    x*exp(r - x - a*y), y*exp(s - y - b*x)

end
