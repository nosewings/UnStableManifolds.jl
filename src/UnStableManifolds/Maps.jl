module Maps

include("Maps/CUDA.jl")
include("Maps/Ricker2D.jl")

function logistic(x, r)
    r*x*(1 - x)
end

function ricker_2d((x, y), a, b, r, s)
    x*exp(r - x - a*y), y*exp(s - y - b*x)
end

end
