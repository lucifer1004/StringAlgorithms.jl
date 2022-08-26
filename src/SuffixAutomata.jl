export SuffixAutomaton, nodes

mutable struct SuffixAutomatonNode{T}
    const len::Int
    link::Int
    const children::Dict{T,Int}
end

SuffixAutomatonNode{T}(len, link) where {T} = SuffixAutomatonNode{T}(len, link, Dict{T,Int}())

mutable struct SuffixAutomaton{T}
    const values::Vector{T}
    const nodes::Vector{SuffixAutomatonNode{T}}
    lastnodeindex::Int
end

nodes(sam::SuffixAutomaton) = sam.nodes

SuffixAutomaton{T}() where {T} = SuffixAutomaton{T}(
    T[],
    [SuffixAutomatonNode{T}(0, 0, Dict{T,Int}())],
    1,
)

function Base.sizehint!(sam::SuffixAutomaton, sz)
    Base.sizehint!(sam.values, sz)
    Base.sizehint!(sam.nodes, 2sz)
end

function Base.push!(sam::SuffixAutomaton{T}, value::T) where {T}
    push!(sam.values, value)
    current = length(sam.nodes) + 1
    current_len = sam.nodes[sam.lastnodeindex].len + 1
    p = sam.lastnodeindex
    while p > 0 && !haskey(sam.nodes[p].children, value)
        sam.nodes[p].children[value] = current
        p = sam.nodes[p].link
    end
    if p == 0
        push!(sam.nodes, SuffixAutomatonNode{T}(current_len, 1))
    else
        q = sam.nodes[p].children[value]
        q_len = q == current ? current_len : sam.nodes[q].len
        if sam.nodes[p].len + 1 == q_len
            push!(sam.nodes, SuffixAutomatonNode{T}(current_len, q))
        else
            clone = current + 1
            push!(sam.nodes, SuffixAutomatonNode{T}(current_len, clone))
            push!(sam.nodes, SuffixAutomatonNode{T}(sam.nodes[p].len + 1, sam.nodes[q].link, copy(sam.nodes[q].children)))
            while p > 0 && get(sam.nodes[p].children, value, nothing) == q
                sam.nodes[p].children[value] = clone
                p = sam.nodes[p].link
            end
            sam.nodes[q].link = clone
        end
    end
    sam.lastnodeindex = current

    return sam
end
