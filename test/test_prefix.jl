@testset "Prefix Function" begin
    function naive(s)
        n = length(s)
        p = fill(0, n)
        for i in 2:n
            prefix = s[begin:i]
            for j in i-1:-1:1
                if prefix[begin:j] == prefix[end-j+1:end]
                    p[i] = j
                    break
                end
            end
        end
        return p
    end

    @testset "Fixed" begin
        @test prefix_function("aaaaa") == [0, 1, 2, 3, 4]
        @test prefix_function("aaabaab") == [0, 1, 2, 0, 1, 2, 0]
        @test prefix_function("abacaba") == [0, 0, 1, 0, 1, 2, 3]
    end

    @testset "Random $alphabet" for alphabet in ['a':'d', 'a':'i', 'a':'z']
        for _ in 1:100
            s = join(rand(alphabet, 100))
            @test prefix_function(s) == naive(s)
        end
    end
end

@testset "Prefix Automata" begin
    function naive(v, alphabet)
        v = collect(v)
        n = length(v)
        m = length(alphabet)
        trans = zeros(Int, m, n + 1)
        for i in 1:n+1
            for (j, c) in enumerate(alphabet)
                nxt = vcat(v[begin:i-1], [c])
                for k in 1:min(i, n)
                    if nxt[end-k+1:end] == v[begin:k]
                        trans[j, i] = k
                    end
                end
            end
        end
        return trans
    end

    @testset "Random $alphabet" for alphabet in ['a':'d', 'a':'i', 'a':'z']
        for _ in 1:10
            s = join(rand(alphabet, 100))
            @test trans(PrefixAutomaton{Char}(s, alphabet)) == naive(s, alphabet)
        end
    end
end
