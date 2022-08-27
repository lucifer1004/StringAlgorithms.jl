export z_algorithm

"""
$(SIGNATURES)

Z Algorithm calculates the longest common prefix of each suffix of the given vector and the whole vector itself. Specially, the Z value of the whole vector is forced to be 0.

# Sample usages

> Usages of Z Algorithm are almost the same as the prefix function.

- Finding all matches

```jldoctest
# The following function finds all occurrences of the pattern in the given vector, including overlapping ones.
function findall(pattern, s)
    n, m = length(s), length(pattern)
    tmp = vcat(collect(pattern), [nothing], collect(s))
    z = z_algorithm(tmp)
    return [i:i+m-1 for i in 1:n if z[i+m+1] == m]
end

findall("aba", "ddabababacc")

# output

3-element Vector{UnitRange{Int64}}:
 3:5
 5:7
 7:9
```
"""
function z_algorithm(v)
    n = length(v)
    z = fill(0, n)
    l, r = 1, 1
    for i in 2:n
        if i <= r && z[i-l+1] < r - i + 1
            z[i] = z[i-l+1]
        else
            z[i] = max(0, r - i + 1)
            while i + z[i] <= n && v[z[i]+1] == v[i+z[i]]
                z[i] += 1
            end
        end
        if i + z[i] - 1 > r
            l = i
            r = i + z[i] - 1
        end
    end
    return z
end
