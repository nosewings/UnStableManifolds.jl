module CUDA where

using CUDAnative

ricker_2d_cuda((x, y), a, b, r, s) =
    x*CUDAnative.exp(r - x - a*y), y*CUDAnative.exp(s - y - b*x)

end