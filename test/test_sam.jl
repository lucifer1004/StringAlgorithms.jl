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

    @testset "Pattern Matching" begin
        @testset "Fixed" begin
            @test count("a", SuffixAutomaton("aba")) == 2
            @test findfirst("a", SuffixAutomaton("aba")) == 1:1
            @test findall("a", SuffixAutomaton("aba"); ascending=true) == [1:1, 3:3]

            @test count("ac", SuffixAutomaton("aaccaa")) == 1
            @test findfirst("ac", SuffixAutomaton("aaccaa")) == 2:3
            @test findall("ac", SuffixAutomaton("aaccaa")) == [2:3]
        end

        @testset "Random $alphabet" for alphabet in ['a':'d', 'a':'i', 'a':'z']
            s = join(rand(alphabet, 100000))
            sam = SuffixAutomaton(s)
            invlink = inverselink(sam)
            freq = freqcount(sam)
            for _ in 1:100
                t = join(rand(alphabet, 5))
                @test count(t, s; overlap=true) == count(t, sam, freq)
                @test findfirst(t, s) == findfirst(t, sam)
                @test findall(t, s; overlap=true) == findall(t, sam, invlink; ascending=true)
            end
        end
    end

    @testset "Longest Common Substring" begin
        function naive(args...)
            shortest = argmin(length.(args))
            n = length(args[shortest])
            best = 0
            bestset = Set{typeof(args[1])}()
            for i in 1:n
                for j in i:n
                    if j - i + 1 >= best
                        good = true
                        for k in eachindex(args)
                            if k != shortest && isnothing(findfirst(args[shortest][i:j], args[k]))
                                good = false
                                break
                            end
                        end
                        if good
                            if j - i + 1 > best
                                bestset = Set{typeof(args[1])}()
                                best = j - i + 1
                            end
                            if j - i + 1 == best
                                push!(bestset, args[shortest][i:j])
                            end
                        end
                    end
                end
            end

            return collect(bestset)
        end

        @testset "Fixed" begin
            @test_throws ErrorException("At least one string/vector should be given!") longestcommonsubstring([])
            @test_throws ErrorException("At least one string/vector should be given!") longestcommonsubstring()
            @test longestcommonsubstring("abc") == ["abc"]
            @test longestcommonsubstring("abc"; lengthonly=true) == 3
            @test longestcommonsubstring("") == []
            @test longestcommonsubstring(""; lengthonly=true) == 0
            @test longestcommonsubstring("abc", "d") == []
            @test longestcommonsubstring("abc", "d"; lengthonly=true) == 0
            @test longestcommonsubstring("aba", "a") == ["a"]
            @test longestcommonsubstring("aba", "a"; lengthonly=true) == 1
            @test sort(longestcommonsubstring("abxbd", "abcbd")) == ["ab", "bd"]
            @test longestcommonsubstring("abxbd", "abcbd"; lengthonly=true) == 2
            @test longestcommonsubstring("abxbd", "abcxbd") == ["xbd"]
            @test longestcommonsubstring("abxbd", "abcxbd"; lengthonly=true) == 3
            @test longestcommonsubstring("aaccaa", "accdaf") == ["acc"]
            @test longestcommonsubstring("aaccaa", "accdaf"; lengthonly=true) == 3
            @test sort(longestcommonsubstring("abxcd", "abtcd", "abecd")) == ["ab", "cd"]
            @test longestcommonsubstring("abxcd", "abtcd", "abecd"; lengthonly=true) == 2
        end

        @testset "Random $alphabet (2 objects)" for alphabet in ['a':'b', 'a':'c', 'a':'d']
            for _ in 1:100
                s = join(rand(alphabet, 100))
                t = join(rand(alphabet, 100))
                @test sort(longestcommonsubstring(s, t)) == sort(naive(s, t))
            end
        end

        @testset "Random $alphabet (multiple objects)" for alphabet in ['a':'b', 'a':'c', 'a':'d']
            for _ in 1:100
                num = rand(3:5)
                args = [join(rand(alphabet, 30)) for _ in 1:num]
                @test sort(longestcommonsubstring(args)) == sort(naive(args...))
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
