var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = StringAlgorithms","category":"page"},{"location":"#StringAlgorithms","page":"Home","title":"StringAlgorithms","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for StringAlgorithms.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [StringAlgorithms]","category":"page"},{"location":"#StringAlgorithms.PalindromicAutomaton-Union{Tuple{}, Tuple{T}} where T","page":"Home","title":"StringAlgorithms.PalindromicAutomaton","text":"Create an empty palindromic automaton of key type T.\n\nThe Palindromic AutoMaton (PAM, also known as the palindrome tree) is a very useful data structure for solving palindrome-related problems. A detailed introduction to PAM can be found via:\n\nWikipedia: Palindrome Tree\nOI-Wiki: 回文树\n\nTo add new values into the automaton, simply use Base.push!.\n\nGetters for the internal fields of the automaton are provided, including:\n\nchildren(pam): Get the children dictionary of the PAM.\nnodes(pam): Get the number of nodes in the PAM.\nlastnodeindex(pam): Get the index of the last node of the PAM.\nlen(pam, i): Get the palindrome length of the i-th node.\nfail(pam, i): Get the fail pointer of the i-th node.\ncnt(pam, i): Get the frequency count of the i-th node. \n\nSample usages\n\nFinding the length of the longest palindromic substring\n\nfunction longest_palindromic_substring(s)\n    pam = PalindromicAutomaton{Char}()\n    hi = 0\n    for ch in s\n        push!(pam, ch)\n        hi = max(hi, len(pam, lastnodeindex(pam)))\n    end\n    return hi\nend\n\nlongest_palindromic_substring(\"ddabababacc\")\n\n# output\n\n7\n\n\n\n\n\n","category":"method"},{"location":"#StringAlgorithms.PrefixAutomaton-Union{Tuple{T}, Tuple{Any, Any}} where T","page":"Home","title":"StringAlgorithms.PrefixAutomaton","text":"Build an automaton based on the prefix function of a given vector. This is useful when the vector to be searched within is very large.\n\n\n\n\n\n","category":"method"},{"location":"#StringAlgorithms.lcp-Tuple{Any, Any}","page":"Home","title":"StringAlgorithms.lcp","text":"Find the longest common prefix of two vectors.\n\n\n\n\n\n","category":"method"},{"location":"#StringAlgorithms.manacher-Tuple{Any}","page":"Home","title":"StringAlgorithms.manacher","text":"The Manacher algorithm proposed by Glenn K. Manacher in 1975.\n\nGiven a vector of length n, so that there will be 2n+1 positions if the intervals between each element are included, returns a vector of length 2n+1 denoting the longest palindrome centered at each position.\n\nSample usages\n\nFinding the length of the longest palindromic substring\n\nfunction longest_palindromic_substring(s)\n    return maximum(manacher(s))\nend\n\nlongest_palindromic_substring(\"ddabababacc\")\n\n# output\n\n7\n\n\n\n\n\n","category":"method"},{"location":"#StringAlgorithms.prefix_function-Tuple{Any}","page":"Home","title":"StringAlgorithms.prefix_function","text":"For each prefix of the given vector, calculate the maximum length such that its nontrivial prefix (not itself) equals to its suffix.\n\nFor example, for string ababc,\n\np[1] = 0\np[2] = 0\np[3] = 1, since the prefix aba has both prefix a and suffix a\np[4] = 2, since the prefix abab has both prefix ab and suffix ab\np[5] = 0\n\nSample usages\n\nFinding all matches (KMP algorithm)\n\n# The following function finds all occurrences of the pattern in the given vector, including overlapping ones, while `Base.findall` only finds non-overlapping ones.\nfunction findall(pattern, s)\n    n, m = length(s), length(pattern)\n    tmp = vcat(collect(pattern), [nothing], collect(s))\n    p = prefix_function(tmp)\n    return [i-m+1:i for i in 1:n if p[i+m+1] == m]\nend\n\nfindall(\"aba\", \"ddabababacc\")\n\n# output\n\n3-element Vector{UnitRange{Int64}}:\n 3:5\n 5:7\n 7:9\n\n\n\n\n\n","category":"method"},{"location":"#StringAlgorithms.z_algorithm-Tuple{Any}","page":"Home","title":"StringAlgorithms.z_algorithm","text":"Z Algorithm calculates the longest common prefix of each suffix of the given vector and the whole vector itself. Specially, the Z value of the whole vector is forced to be 0.\n\nSample usages\n\nUsages of Z Algorithm are almost the same as the prefix function.\n\nFinding all matches\n\n# The following function finds all occurrences of the pattern in the given vector, including overlapping ones, while `Base.findall` only finds non-overlapping ones.\nfunction findall(pattern, s)\n    n, m = length(s), length(pattern)\n    tmp = vcat(collect(pattern), [nothing], collect(s))\n    z = z_algorithm(tmp)\n    return [i:i+m-1 for i in 1:n if z[i+m+1] == m]\nend\n\nfindall(\"aba\", \"ddabababacc\")\n\n# output\n\n3-element Vector{UnitRange{Int64}}:\n 3:5\n 5:7\n 7:9\n\n\n\n\n\n","category":"method"}]
}
