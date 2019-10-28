using CUDAnative


function logistic(
    x :: T,
    r :: T,
) :: T where T
    r*x*(1 - x)
end


function ricker_2d(
    (x, y) :: Tuple{T, T},
    a :: T,
    b :: T,
    r :: T,
    s :: T,
) :: Tuple{T, T} where T
    x*exp(r - x - a*y), y*exp(s - y - b*x)
end


function ricker_2d_cuda(
    (x, y) :: Tuple{T, T},
    a :: T,
    b :: T,
    r :: T,
    s :: T,
) :: Tuple{T, T} where T
    x*CUDAnative.exp(r - x - a*y), y*CUDAnative.exp(s - y - b*x)
end
