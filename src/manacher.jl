export manacher

"""
$(SIGNATURES)

The Manacher algorithm proposed by Glenn K. Manacher in 1975.

Given a vector of length `n`, so that there will be `2n+1` positions if the intervals between each element are included, returns a vector of length `2n+1` denoting the longest palindrome centered at each position.

# Sample usages

- Finding the length of the longest palindromic substring

```jldoctest
function longest_palindromic_substring(s)
    return maximum(manacher(s))
end

longest_palindromic_substring("ddabababacc")

# output

7
```
"""
function manacher(v)
    T = eltype(v)
    n = length(v)
    ve::Vector{Union{T,Nothing}} = fill(nothing, 2n + 1)
    for i in 1:n
        ve[2i] = v[i]
    end

    N = 2n + 1
    ret = fill(0, N)
    l = 1
    r = -1
    for i in 1:N
        k = i > r ? 1 : min(ret[l+r-i], r - i + 1)
        while i > k && i + k <= N && ve[i-k] == ve[i+k]
            k += 1
        end
        ret[i] = k
        k -= 1
        if i + k > r
            l = i - k
            r = i + k
        end
    end

    return ret .- 1
end
