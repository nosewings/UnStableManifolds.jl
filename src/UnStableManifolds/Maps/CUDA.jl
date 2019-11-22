module CUDA

using CUDAnative

function ricker_2d(
    (x, y) :: Tuple{T, T},
    a :: T,
    b :: T,
    r :: T,
    s :: T
) where {T}
    x*CUDAnative.exp(r - x - a*y), y*CUDAnative.exp(s - y - b*x)
end

end
