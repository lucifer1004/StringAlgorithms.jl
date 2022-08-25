export PalindromicAutomaton, children, nodes, lastnodeindex, len, fail, cnt

const ODD_ROOT = 1
const EVEN_ROOT = 2

mutable struct PalindromicAutomaton{T} <: AbstractVector{T}
    const values::Vector{T}
    const len::Vector{Int}
    const children::Dict{Tuple{Int,T},Int}
    const fail::Vector{Int}
    const cnt::Vector{Int}
    lastnodeindex::Int
end

Base.size(pam::PalindromicAutomaton) = Base.size(pam.values)
Base.getindex(pam::PalindromicAutomaton, i) = i == 0 ? nothing : pam.values[i]
function Base.sizehint!(pam::PalindromicAutomaton, sz)
    Base.sizehint!(pam.values, sz)
    Base.sizehint!(pam.len, sz + 2)
    Base.sizehint!(pam.fail, sz + 2)
    Base.sizehint!(pam.cnt, sz + 2)
end

@inline children(pam::PalindromicAutomaton) = pam.children
@inline nodes(pam::PalindromicAutomaton) = length(pam.cnt)
@inline lastnodeindex(pam::PalindromicAutomaton) = pam.lastnodeindex
@inline len(pam::PalindromicAutomaton, i) = pam.len[i]
@inline fail(pam::PalindromicAutomaton, i) = pam.fail[i]
@inline cnt(pam::PalindromicAutomaton, i) = pam.cnt[i]

function createnode!(pam::PalindromicAutomaton{T}, node_len, node_fail) where {T}
    push!(pam.len, node_len)
    push!(pam.fail, node_fail)
    push!(pam.cnt, 0)
end

"""
Create an empty palindromic automaton of key type `T`.

The Palindromic AutoMaton (PAM, also known as the palindrome tree) is a very useful data structure for solving palindrome-related problems. A detailed introduction to PAM can be found via:

- [Wikipedia: Palindrome Tree](https://en.wikipedia.org/wiki/Palindrome_tree)
- [OI-Wiki: 回文树](https://oi-wiki.org/string/pam/)

To add new values into the automaton, simply use `Base.push!`.

Getters for the internal fields of the automaton are provided, including:

- `children(pam)`: Get the children dictionary of the PAM.
- `nodes(pam)`: Get the number of nodes in the PAM.
- `lastnodeindex(pam)`: Get the index of the last node of the PAM.
- `len(pam, i)`: Get the palindrome length of the i-th node.
- `fail(pam, i)`: Get the fail pointer of the i-th node.
- `cnt(pam, i)`: Get the frequency count of the i-th node. 

# Sample usages

- Finding the length of the longest palindromic substring

```jldoctest
function longest_palindromic_substring(s)
    pam = PalindromicAutomaton{Char}()
    hi = 0
    for ch in s
        push!(pam, ch)
        hi = max(hi, len(pam, lastnodeindex(pam)))
    end
    return hi
end

longest_palindromic_substring("ddabababacc")

# output

7
```
"""
function PalindromicAutomaton{T}() where {T}
    pam = PalindromicAutomaton{T}(T[], Int[], Dict(), Int[], Int[], 1)
    createnode!(pam, -1, ODD_ROOT)
    createnode!(pam, 0, ODD_ROOT)
    return pam
end

function getfail(pam::PalindromicAutomaton{T}, x) where {T}
    while pam[end-pam.len[x]-1] != pam[end]
        x = pam.fail[x]
    end
    return x
end

function Base.push!(pam::PalindromicAutomaton{T}, value::T) where {T}
    push!(pam.values, value)
    now = getfail(pam, pam.lastnodeindex)
    if !haskey(pam.children, (now, value))
        createnode!(pam, pam.len[now] + 2, get(pam.children, (getfail(pam, pam.fail[now]), value), EVEN_ROOT))
        pam.children[(now, value)] = length(pam.len)
    end
    pam.lastnodeindex = pam.children[(now, value)]
    pam.cnt[pam.lastnodeindex] += 1
    return pam
end
