@testset "Z Algorithm" begin
    function naive(s)
        n = length(s)
        z = fill(0, n)
        for i in 2:n
            suffix = s[i:end]
            while z[i] + 1 <= length(suffix) && suffix[z[i]+1] == s[z[i]+1]
                z[i] += 1
            end
        end
        return z
    end

    @testset "Fixed" begin
        @test z_algorithm("aaaaa") == [0, 4, 3, 2, 1]
        @test z_algorithm("aaabaab") == [0, 2, 1, 0, 2, 1, 0]
        @test z_algorithm("abacaba") == [0, 0, 1, 0, 3, 0, 1]
    end

    @testset "Random $alphabet" for alphabet in ['a':'d', 'a':'i', 'a':'z']
        for _ in 1:100
            s = join(rand(alphabet, 100))
            @test z_algorithm(s) == naive(s)
        end
    end
end
