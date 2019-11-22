module Util

# This is a stupid trick, but I'm kind of proud of it.
function broadcast_size(x...)
    broadcasted = tuple.(x...)
    broadcasted isa Tuple ? (1,) : size(broadcasted)
end

function Base.:-(x :: Tuple, y :: Tuple)
    x .- y
end

function Base.isapprox(x :: Tuple, y :: Tuple; kwargs...)
    Base.isapprox(collect(x), collect(y); kwargs...)
end

end
