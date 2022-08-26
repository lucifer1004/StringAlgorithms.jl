using StringAlgorithms
using Test

@testset "StringAlgorithms.jl" begin
    include("test_manacher.jl")
    include("test_prefix.jl")
    include("test_z.jl")
    include("test_sam.jl")
    include("test_pam.jl")
end
