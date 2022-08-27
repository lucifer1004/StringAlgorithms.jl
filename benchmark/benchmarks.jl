using Pkg
tempdir = mktempdir()
Pkg.activate(tempdir)
Pkg.develop(PackageSpec(path=joinpath(@__DIR__, "..")))
Pkg.add(["BenchmarkTools", "PkgBenchmark", "Random"])
Pkg.resolve()

using DataStructures
using BenchmarkTools

const SUITE = BenchmarkGroup()

SUITE["SuffixAutomata"] = include("bench_sam.jl")
