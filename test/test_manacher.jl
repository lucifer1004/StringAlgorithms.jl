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

        @testset "Random a..d" begin
            for _ in 1:100
                s = join(Char.(rand(97:100, 100)))
                @test solve(s) == naive(s)
            end
        end

        @testset "Random a..i" begin
            for _ in 1:100
                s = join(Char.(rand(97:106, 100)))
                @test solve(s) == naive(s)
            end
        end

        @testset "Random a..z" begin
            for _ in 1:100
                s = join(Char.(rand(97:122, 100)))
                @test solve(s) == naive(s)
            end
        end
    end
end
