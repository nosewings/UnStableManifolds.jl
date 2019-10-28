id(x...) :: Tuple = x


# This is a stupid trick, but I'm kind of proud of it.
function broadcast_size(arrays...) :: Tuple
    broadcasted = id.(arrays...)
    broadcasted isa Tuple ? (1,) : size(broadcasted)
end


macro bigf(precision, expr)
    esc(_bigf(precision, expr))
end

function _bigf(precision, expr :: Expr)

end
