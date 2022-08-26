@testset "SuffixAutomaton" begin
    @testset "Count distinct non-empty substrings" begin
        function naive(s)
            n = length(s)
            return length(Set([s[i:j] for i in 1:n for j in i:n]))
        end

        function solve(s)
            sam = SuffixAutomaton(s)
            nodes = nodeoriented(sam)
            return sum(nodes[i].len - nodes[nodes[i].link].len for i in eachindex(nodes) if i >= 2)
        end

        @testset "Fixed" begin
            @test solve("aba") == 5
            @test solve("aaccaa") == 16
        end

        @testset "Random $alphabet" for alphabet in ['a':'d', 'a':'i', 'a':'z']
            for _ in 1:100
                s = join(rand(alphabet, 100))
                @test solve(s) == naive(s)
            end
        end
    end

    @testset "Longest Common Substring of Two" begin
        function naive(s, t)
            n = length(t)
            best = 0
            bestpos = 0
            for i in 1:n
                for j in i:n
                    if j - i + 1 > best && !isnothing(findfirst(t[i:j], s))
                        best = j - i + 1
                        bestpos = j
                    end
                end
            end
            return t[bestpos-best+1:bestpos]
        end

        @testset "Fixed" begin
            @test longestcommonsubstring("aba", "a") == "a"
            @test longestcommonsubstring("aaccaa", "accdaf") == "acc"
        end

        @testset "Random $alphabet" for alphabet in ['a':'b', 'a':'c', 'a':'d']
            for _ in 1:100
                s = join(rand(alphabet, 100))
                t = join(rand(alphabet, 100))
                @test longestcommonsubstring(s, t) == naive(s, t)
            end
        end
    end

    @testset "Minimum Rotation" begin
        function naive(s)
            n = length(s)
            v = vcat(collect(s), collect(s))
            minrot = minimum(v[i:i+n-1] for i in 1:n)
            if typeof(s) <: AbstractString
                minrot = join(minrot)
            end
            return minrot
        end

        @testset "Fixed" begin
            minimumrotation("aba") == "aab"
            minimumrotation([2, 3, 1]) == [1, 2, 3]
        end

        @testset "Random $alphabet" for alphabet in ['a':'d', 'a':'i', 'a':'z']
            for _ in 1:100
                s = join(rand(alphabet, 100))
                @test minimumrotation(s) == naive(s)
            end
        end
    end

    @testset "Maximum Rotation" begin
        function naive(s)
            n = length(s)
            v = vcat(collect(s), collect(s))
            maxrot = maximum(v[i:i+n-1] for i in 1:n)
            if typeof(s) <: AbstractString
                maxrot = join(maxrot)
            end
            return maxrot
        end

        @testset "Fixed" begin
            maximumrotation("aba") == "baa"
            maximumrotation([2, 3, 1]) == [3, 1, 2]
        end

        @testset "Random $alphabet" for alphabet in ['a':'d', 'a':'i', 'a':'z']
            for _ in 1:100
                s = join(rand(alphabet, 100))
                @test maximumrotation(s) == naive(s)
            end
        end
    end
end
