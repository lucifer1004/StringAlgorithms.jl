module BenchSuffixAutomata

using StringAlgorithms
using BenchmarkTools
using Random

suite = BenchmarkGroup()
textfiles = ["little_prince", "heart_of_darkness"]
texts = Dict(textfile => read(joinpath(@__DIR__, "$textfile.txt"), String) for textfile in textfiles)
sams = Dict(textfile => SuffixAutomaton(texts[textfile]) for textfile in textfiles)
invlinks = Dict(textfile => inverselink(sams[textfile]) for textfile in textfiles)
freqs = Dict(textfile => freqcount(sams[textfile]) for textfile in textfiles)

function findfirst_many(patterns, sam)
    for pattern in patterns
        findfirst(pattern, sam)
    end
end

function findfirst_many_std(patterns, text)
    for pattern in patterns
        findfirst(pattern, text)
    end
end


function findall_many(patterns, sam, invlink)
    for pattern in patterns
        findall(pattern, sam, invlink)
    end
end

function findall_many_std(patterns, text)
    for pattern in patterns
        findall(pattern, text; overlap=true)
    end
end

function count_many(patterns, sam, freq)
    for pattern in patterns
        count(pattern, sam, freq)
    end
end

function count_many_std(patterns, text)
    for pattern in patterns
        count(pattern, text)
    end
end

Random.seed!(42)

for pattern_size in [1, 2, 5, 10]
    patterns = [join(rand('a':'z', pattern_size)) for _ in 1:100]
    for key in keys(texts)
        suite["$(key)_findfirst_sam_plen=$(pattern_size)"] = @benchmarkable findfirst_many($patterns, $(sams[key]))
        suite["$(key)_findfirst_std_plen=$(pattern_size)"] = @benchmarkable findfirst_many_std($patterns, $(texts[key]))
        suite["$(key)_findall_sam_plen=$(pattern_size)"] = @benchmarkable findall_many($patterns, $(sams[key]), $(invlinks[key]))
        suite["$(key)_findall_std_plen=$(pattern_size)"] = @benchmarkable findall_many_std($patterns, $(texts[key]))
        suite["$(key)_count_sam_plen=$(pattern_size)"] = @benchmarkable count_many($patterns, $(sams[key]), $(freqs[key]))
        suite["$(key)_count_std_plen=$(pattern_size)"] = @benchmarkable count_many_std($patterns, $(texts[key]))
    end
end

end

BenchSuffixAutomata.suite
