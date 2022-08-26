@testset "Manacher" begin
    @testset "Longest Palindromic Substring" begin
        function naive(s)
            n = length(s)
            return maximum(j - i + 1 for i in 1:n for j in i:n if s[i:j] == reverse(s[i:j]))
        end

        function solve(s)
            return maximum(manacher(s))
        end

        @testset "Fixed" begin
            @test solve("abacaba") == 7
            @test solve("www") == 3
            @test solve("dababababae") == 9
        end

        @testset "Random $alphabet" for alphabet in ['a':'d', 'a':'i', 'a':'z']
            for _ in 1:100
                s = join(rand(alphabet, 100))
                @test solve(s) == naive(s)
            end
        end
    end
end
