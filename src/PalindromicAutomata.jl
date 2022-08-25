export PalindromicAutomaton, nodes

mutable struct PalindromicAutomatonNode{T}
    const len::Int
    const children::Dict{T,Int}
    const fail::Int
    cnt::Int

    function PalindromicAutomatonNode{T}(len, fail) where {T}
        return new{T}(len, Dict(), fail, 0)
    end
end

mutable struct PalindromicAutomaton{T} <: AbstractVector{T}
    const nodes::Vector{PalindromicAutomatonNode{T}}
    const values::Vector{T}
    lastnodeindex::Int
end

Base.size(pam::PalindromicAutomaton) = Base.size(pam.values)
Base.lastindex(pam::PalindromicAutomaton) = Base.lastindex(pam.values)
Base.getindex(pam::PalindromicAutomaton, i) = i == 0 ? nothing : pam.values[i]

@inline nodes(pam::PalindromicAutomaton) = pam.nodes
@inline lastnodeindex(pam::PalindromicAutomaton) = pam.lastnodeindex
@inline lastnodeindex!(pam::PalindromicAutomaton, x) = pam.lastnodeindex = x
@inline lastnode(pam::PalindromicAutomaton) = nodes(pam)[lastnodeindex(pam)]

function PalindromicAutomaton{T}() where {T}
    odd = PalindromicAutomatonNode{T}(-1, 1)
    even = PalindromicAutomatonNode{T}(0, 2)
    return PalindromicAutomaton{T}([even, odd], T[], 1)
end

function getfail(pam::PalindromicAutomaton{T}, x) where {T}
    while pam[end-nodes(pam)[x].len-1] != pam[end]
        x = nodes(pam)[x].fail
    end
    return x
end

function Base.push!(pam::PalindromicAutomaton{T}, node::PalindromicAutomatonNode{T}) where {T}
    push!(nodes(pam), node)
    return length(nodes(pam))
end

function Base.push!(pam::PalindromicAutomaton{T}, value::T) where {T}
    push!(pam.values, value)
    now = nodes(pam)[getfail(pam, lastnodeindex(pam))]
    if !haskey(now.children, value)
        now.children[value] = push!(
            pam,
            PalindromicAutomatonNode{T}(
                now.len + 2,
                get(nodes(pam)[getfail(pam, now.fail)].children, value, 1)
            ),
        )
    end
    lastnodeindex!(pam, now.children[value])
    lastnode(pam).cnt += 1
    return pam
end
