module Util

id(x...) = x

# This is a stupid trick, but I'm kind of proud of it.
function broadcast_size(arrays...)
    broadcasted = id.(arrays...)
    broadcasted isa Tuple ? (1,) : size(broadcasted)
end

end
