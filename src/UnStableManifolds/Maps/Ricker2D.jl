module Ricker2D

function coexistence(a, b, r, s)
    denom = 1 - a*b
    (r - a*s)/denom, (s - b*r)/denom
end

end
