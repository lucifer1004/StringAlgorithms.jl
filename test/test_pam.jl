@testset "PalindromicAutomaton" begin
    @testset "APIO2014 Palindromes (https://www.luogu.com.cn/problem/P3649)" begin
        function naive(s)
            n = length(s)
            cnt = Dict{String,Int}()
            for i in 1:n
                for j in i:n
                    if s[i:j] == reverse(s[i:j])
                        cnt[s[i:j]] = get(cnt, s[i:j], 0) + 1
                    end
                end
            end
            return maximum(length(key) * cnt[key] for key in keys(cnt))
        end

        function solve(s)
            pam = PalindromicAutomaton{Char}()
            sizehint!(pam, length(s))
            for ch in s
                push!(pam, ch)
            end

            c = zeros(Int, nodes(pam))
            for i in length(c):-1:1
                c[i] += cnt(pam, i)
                c[fail(pam, i)] += c[i]
            end
            return maximum(len(pam, i) * c[i] for i in eachindex(c))
        end

        @testset "Fixed" begin
            @test solve("abacaba") == 7
            @test solve("www") == 4
            @test solve("ababababa") == 15
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

    @testset "Luogu P4555 Longest Bi-palindrome (https://www.luogu.com.cn/problem/P4555)" begin
        function naive(s)
            n = length(s)
            hi = 0
            for i in 1:n
                for j in i+1:n
                    for k in i:j-1
                        if s[i:k] == reverse(s[i:k]) && s[k+1:j] == reverse(s[k+1:j])
                            hi = max(hi, j - i + 1)
                            break
                        end
                    end
                end
            end
            return hi
        end

        function solve(s)
            n = length(s)
            L = zeros(Int, n)
            R = zeros(Int, n)

            pam = PalindromicAutomaton{Char}()
            sizehint!(pam, n)
            for i in 1:n
                push!(pam, s[i])
                R[i] = len(pam, lastnodeindex(pam))
            end

            pam = PalindromicAutomaton{Char}()
            sizehint!(pam, n)
            for i in n:-1:1
                push!(pam, s[i])
                L[i] = len(pam, lastnodeindex(pam))
            end

            return maximum(R[i] + L[i+1] for i in 1:n-1)
        end

        @testset "Fixed" begin
            @test solve("baacaabbacabb") == 12
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
