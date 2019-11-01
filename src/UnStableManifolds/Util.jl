module Util

# This is a stupid trick, but I'm kind of proud of it.
function broadcast_size(x...)
    broadcasted = tuple.(x...)
    broadcasted isa Tuple ? (1,) : size(broadcasted)
end

end
