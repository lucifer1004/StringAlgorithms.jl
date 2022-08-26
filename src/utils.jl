export lcp

"""
Find the longest common prefix of two vectors.
"""
function lcp(a, b)
    l = 0
    for (ai, bi) in zip(a, b)
        if ai == bi
            l += 1
        else
            break
        end
    end
    return l
end
