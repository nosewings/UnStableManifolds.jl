module Maps

include("Maps/CUDA.jl")
include("Maps/Ricker2D.jl")

function logistic(x :: T, r :: T) where {T}
    r*x*(1 - x)
end

const ricker_2d = Ricker2D.apply

function logistic_2d(
    (x, y) :: Tuple{T, T},
    a :: T,
    b :: T,
    c :: T,
    d :: T,
) where {T}
    (a*x*(one(T) - x))/(1 + c*y), (b*y*(one(T) - y))/(1 + d*x)
end

function cournot(
    (x, y) :: Tuple{T, T},
    a :: T,
    b :: T,
    c :: T,
    d :: T
) where {T}
    a*x*(one(T) - x - c*y), b*y*(one(T) - y - d*x)
end

end
