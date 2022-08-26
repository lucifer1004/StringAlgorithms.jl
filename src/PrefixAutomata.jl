export PrefixAutomaton, prefix_function, alphabet, reversealphabet, trans

"""
For each prefix of the given vector, calculate the maximum length such that its nontrivial prefix (not itself) equals to its suffix.

For example, for string `ababc`,

- `p[1] = 0`
- `p[2] = 0`
- `p[3] = 1`, since the prefix `aba` has both prefix `a` and suffix `a`
- `p[4] = 2`, since the prefix `abab` has both prefix `ab` and suffix `ab`
- `p[5] = 0`

# Sample usages

- Finding all matches (KMP algorithm)

```jldoctest
# The following function finds all occurrences of the pattern in the given vector, including overlapping ones, while `Base.findall` only finds non-overlapping ones.
function findall(pattern, s)
    n, m = length(s), length(pattern)
    tmp = vcat(collect(pattern), [nothing], collect(s))
    p = prefix_function(tmp)
    return [i-m+1:i for i in 1:n if p[i+m+1] == m]
end

findall("aba", "ddabababacc")

# output

3-element Vector{UnitRange{Int64}}:
 3:5
 5:7
 7:9
```
"""
function prefix_function(v)
    n = length(v)
    p = fill(0, n)
    for i in 2:n
        j = p[i-1]
        while j > 0 && v[i] != v[j+1]
            j = p[j]
        end
        if v[i] == v[j+1]
            j += 1
        end
        p[i] = j
    end
    return p
end

struct PrefixAutomaton{T}
    alphabet::Vector{T}
    alphabet_reverse::Dict{T,Int}
    trans::Matrix{Int}
end

"""
Build an automaton based on the prefix function of a given vector. This is useful when the vector to be searched within is very large.
"""
function PrefixAutomaton{T}(v, alphabet) where {T}
    alphabet = collect(alphabet)
    reversealphabet = Dict(ch => i for (i, ch) in enumerate(alphabet))
    v = vcat(collect(v), [nothing])
    n = length(v)
    p = prefix_function(v)
    m = length(alphabet)
    trans = zeros(Int, m, n)
    for i in 1:n
        for c in 1:m
            if i > 1 && alphabet[c] != v[i]
                trans[c, i] = trans[c, p[i-1]+1]
            else
                trans[c, i] = i - 1 + Int(alphabet[c] == v[i])
            end
        end
    end
    return PrefixAutomaton{T}(alphabet, reversealphabet, trans)
end

alphabet(pa::PrefixAutomaton) = pa.alphabet
reversealphabet(pa::PrefixAutomaton) = pa.reversealphabet
trans(pa::PrefixAutomaton) = pa.trans
