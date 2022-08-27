# Notes on running benchmarks with PkgBenchmark.jl

## To run benchmark locally

In the root directory of the project, run:

```bash
julia --project=benchmark -e '
    using Pkg; Pkg.instantiate();
    include("benchmark/runbenchmarks.jl");'
```
