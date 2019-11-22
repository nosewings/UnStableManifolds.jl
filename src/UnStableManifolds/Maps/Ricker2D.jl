module Ricker2D

function apply(
    (x, y) :: Tuple{T, T},
    a :: T,
    b :: T,
    r :: T,
    s :: T,
) where {T}
    x*exp(r - x - a*y), y*exp(s - y - b*x)
end

function coexistence(a, b, r, s)
    denom = 1 - a*b
    (r - a*s)/denom, (s - b*r)/denom
end

end
