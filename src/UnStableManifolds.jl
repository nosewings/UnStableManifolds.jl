module UnStableManifolds

# I cannot believe that in the Year of Our Lord 2019 we are still making
# languages in which I have to TEXTUALLY INCLUDE FILES IN THE RIGHT ORDER. I
# think the developers want me to hate their language.

include("UnStableManifolds/Util.jl")

include("UnStableManifolds/FindDoublingCycles.jl")
include("UnStableManifolds/Iterates.jl")
include("UnStableManifolds/Maps.jl")

include("UnStableManifolds/Batch.jl")

using .FindDoublingCycles: find_doubling_cycles
using .Iterates: iterates

end
