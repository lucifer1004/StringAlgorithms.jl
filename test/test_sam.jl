@testset "SuffixAutomaton" begin
    @testset "Count distinct non-empty substrings" begin
        function naive(s)
            n = length(s)
            return length(Set([s[i:j] for i in 1:n for j in i:n]))
        end

        function solve(s)
            T = eltype(s)
            sam = SuffixAutomaton{T}()
            for ch in s
                push!(sam, ch)
            end

            return sum(node.len - nodes(sam)[node.link].len for node in nodes(sam)[2:end])
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
end
