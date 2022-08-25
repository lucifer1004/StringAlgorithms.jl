@testset "PalindromicAutomaton" begin
    @testset "APIO2014(Luogu P3649)" begin
        function solve(s)
            pam = PalindromicAutomaton{Char}()
            for ch in s
                push!(pam, ch)
            end

            cnt = zeros(Int, length(nodes(pam)))
            for i in length(cnt):-1:1
                cnt[i] += nodes(pam)[i].cnt
                cnt[nodes(pam)[i].fail] += cnt[i]
            end
            return maximum(nodes(pam)[i].len * cnt[i] for i in eachindex(cnt))
        end

        @test solve("abacaba") == 7
        @test solve("www") == 4
        @test solve("ababababa") == 15
    end
end
