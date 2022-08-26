export SuffixAutomaton, nodeoriented, toposort, longestcommonsubstring, minimumrotation, maximumrotation

struct SuffixAutomatonNode{T}
    len::Int
    link::Int
    firstpos::Int
    children::Dict{T,Int}
end

mutable struct SuffixAutomaton{T} <: AbstractVector{T}
    const values::Vector{T}
    const len::Vector{Int}
    const link::Vector{Int}
    const firstpos::Vector{Int}
    const nodefirst::Vector{Int}
    const nodelast::Vector{Int}
    const nxt::Vector{Int}
    const listvalues::Vector{T}
    const children::Dict{Tuple{Int,T},Int}
    lastnodeindex::Int
end

Base.size(sam::SuffixAutomaton) = size(sam.values)
Base.getindex(sam::SuffixAutomaton, i) = sam.values[i]

"""
Create an empty suffix automaton of key type `T`.

The Suffix AutoMaton (SAM) is a very useful data structure for solving string-related problems. A detailed introduction to SAM can be found via:

- [Wikipedia: Suffix Automaton](https://en.wikipedia.org/wiki/Suffix_automaton)
- [OI-Wiki: 后缀自动机](https://oi-wiki.org/string/sam/)
"""
SuffixAutomaton{T}() where {T} = SuffixAutomaton{T}(
    T[], # values
    [0], # len
    [0], # link
    [0], # firstpos
    [0], # nodefirst
    [0], # nodelast
    Int[], # nxt
    T[], # listvalues
    Dict{Tuple{Int,T},Int}(), # children
    1, # lastnodeindex
)

function SuffixAutomaton(v)
    T = eltype(v)
    sam = SuffixAutomaton{T}()
    sizehint!(sam, length(v))
    for vi in v
        push!(sam, vi)
    end
    return sam
end

function Base.sizehint!(sam::SuffixAutomaton, sz)
    sizehint!(sam.values, sz)
    sizehint!(sam.len, sz + 1)
    sizehint!(sam.link, sz + 1)
    sizehint!(sam.firstpos, sz + 1)
    sizehint!(sam.nodefirst, sz + 1)
    sizehint!(sam.nodelast, sz + 1)
    sizehint!(sam.nxt, 2sz)
    sizehint!(sam.listvalues, 2sz)
    sizehint!(sam.children, 2sz)
end

function _insertnode!(sam::SuffixAutomaton, len, link, firstpos)
    push!(sam.len, len)
    push!(sam.link, link)
    push!(sam.firstpos, firstpos)
    push!(sam.nodefirst, 0)
    push!(sam.nodelast, 0)
end

function _clonenode!(sam::SuffixAutomaton, len, source)
    _insertnode!(sam, len, sam.link[source], sam.firstpos[source])
    current = lastindex(sam.len)
    p = sam.nodefirst[source]
    while p != 0
        key = sam.listvalues[p]
        _insertkey!(sam, current, key, sam.children[(source, key)])
        p = sam.nxt[p]
    end
end

function _insertkey!(sam::SuffixAutomaton{T}, i, key::T, value) where {T}
    push!(sam.nxt, 0)
    push!(sam.listvalues, key)
    current = lastindex(sam.nxt)
    sam.children[(i, key)] = value
    if sam.nodefirst[i] == 0
        sam.nodefirst[i] = current
    end
    if sam.nodelast[i] != 0
        sam.nxt[sam.nodelast[i]] = current
    end
    sam.nodelast[i] = current
end

function Base.push!(sam::SuffixAutomaton{T}, value::T) where {T}
    push!(sam.values, value)
    current = lastindex(sam.len) + 1
    p = sam.lastnodeindex
    current_len = sam.len[p] + 1
    while p > 0 && !haskey(sam.children, (p, value))
        _insertkey!(sam, p, value, current)
        p = sam.link[p]
    end
    if p == 0
        _insertnode!(sam, current_len, 1, current_len)
    else
        q = sam.children[(p, value)]
        q_len = q == current ? current_len : sam.len[q]
        if sam.len[p] + 1 == q_len
            _insertnode!(sam, current_len, q, current_len)
        else
            clone = current + 1
            _insertnode!(sam, current_len, clone, current_len)
            _clonenode!(sam, sam.len[p] + 1, q)
            while p > 0 && get(sam.children, (p, value), nothing) == q
                sam.children[(p, value)] = clone
                p = sam.link[p]
            end
            sam.link[q] = clone
        end
    end
    sam.lastnodeindex = current

    return sam
end

"""
Transform the internal representation of the suffix automaton into a more user-friendly node-oriented representation, which might be useful when users want to access some internal information.
"""
function nodeoriented(sam::SuffixAutomaton{T}) where {T}
    map(eachindex(sam.len)) do i
        len = sam.len[i]
        link = sam.link[i]
        firstpos = sam.firstpos[i]
        children = Dict{T,Int}()
        p = sam.nodefirst[i]
        while p != 0
            key = sam.listvalues[p]
            children[key] = sam.children[(i, key)]
            p = sam.nxt[p]
        end
        SuffixAutomatonNode(len, link, firstpos, children)
    end
end

"""
Find the topological order of all nodes in a suffix automaton.
"""
function toposort(sam::SuffixAutomaton)
    n = length(sam.len)
    t = fill(0, length(sam) + 1)
    a = fill(0, n)
    for i in 1:n
        t[sam.len[i]+1] += 1
    end
    for i in 2:length(sam)+1
        t[i] += t[i-1]
    end
    for i in 1:n
        a[t[sam.len[i]+1]] = i
        t[sam.len[i]+1] -= 1
    end
    return a
end

"""
Find the longest common non-empty substring/sub-vector of multiple strings/vectors. 

When there are more than one with the same length, all distinct answers will be returned in a random order.
"""
function longestcommonsubstring(args...; lengthonly=false)
    length(args) == 0 && error("At least one string/vector should be given!")

    VT = typeof(args[1])
    if length(args) == 1
        return lengthonly ? length(args[1]) : length(args[1]) > 0 ? [args[1]] : VT[]
    end

    shortest = argmin(length.(args))
    if length(args[shortest]) == 0
        return lengthonly ? 0 : VT[]
    end

    sam = SuffixAutomaton(args[shortest])
    n = length(sam.len)
    minn = copy(sam.len)
    maxi = fill(0, n)
    topo = toposort(sam)
    for idx in eachindex(args)
        if idx == shortest
            continue
        end

        fill!(maxi, 0)
        v = 1
        l = 0
        for ti in args[idx]
            while v > 1 && !haskey(sam.children, (v, ti))
                v = sam.link[v]
                l = sam.len[v]
            end
            if haskey(sam.children, (v, ti))
                v = sam.children[(v, ti)]
                l += 1
            end
            maxi[v] = max(maxi[v], l)
        end

        for k in n:-1:2
            i = topo[k]
            minn[i] = min(minn[i], maxi[i])
            maxi[sam.link[i]] = max(maxi[sam.link[i]], maxi[i])
        end
    end

    hi = maximum(minn)
    if lengthonly
        return hi
    end
    if hi == 0
        return VT[]
    end

    s = Set{VT}()
    for i in 2:n
        if minn[i] == hi
            start = sam.firstpos[i] - hi + 1
            push!(s, args[shortest][start:start+hi-1])
        end
    end

    return collect(s)
end

longestcommonsubstring(v::AbstractVector) = longestcommonsubstring(v...)

"""
Find the minimum of all rotations of the given string/vector. 

For example, string `aab` has three rotations:, `aab`, `aba`, `baa`, and `aab` is the minimum rotation.
"""
function minimumrotation(s)
    n = length(s)
    T = eltype(s)
    v = vcat(collect(s), collect(s))
    sam = SuffixAutomaton(v)
    p = 1
    minrot = T[]
    for _ in 1:n
        ptr = sam.nodefirst[p]
        small = sam.listvalues[ptr]
        while ptr != 0
            ptr = sam.nxt[ptr]
            if ptr > 0 && sam.listvalues[ptr] < small
                small = sam.listvalues[ptr]
            end
        end
        push!(minrot, small)
        p = sam.children[(p, small)]
    end

    if typeof(s) <: AbstractString
        minrot = join(minrot)
    end
    return minrot
end

"""
Find the maximum of all rotations of the given string/vector.

For example, string `aab` has three rotations:, `aab`, `aba`, `baa`, and `baa` is the maximum rotation.
"""
function maximumrotation(s)
    n = length(s)
    T = eltype(s)
    v = vcat(collect(s), collect(s))
    sam = SuffixAutomaton(v)
    p = 1
    maxrot = T[]
    for _ in 1:n
        ptr = sam.nodefirst[p]
        large = sam.listvalues[ptr]
        while ptr != 0
            ptr = sam.nxt[ptr]
            if ptr > 0 && sam.listvalues[ptr] > large
                large = sam.listvalues[ptr]
            end
        end
        push!(maxrot, large)
        p = sam.children[(p, large)]
    end

    if typeof(s) <: AbstractString
        maxrot = join(maxrot)
    end
    return maxrot
end
