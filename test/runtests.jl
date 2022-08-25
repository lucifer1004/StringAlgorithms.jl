using StringAlgorithms
using Test

@testset "StringAlgorithms.jl" begin
    include("test_manacher.jl")
    include("test_pam.jl")
end
