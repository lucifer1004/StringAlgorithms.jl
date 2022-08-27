# StringAlgorithms

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://lucifer1004.github.io/StringAlgorithms.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://lucifer1004.github.io/StringAlgorithms.jl/dev/)
[![Build Status](https://github.com/lucifer1004/StringAlgorithms.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/lucifer1004/StringAlgorithms.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/lucifer1004/StringAlgorithms.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/lucifer1004/StringAlgorithms.jl)

This package implements a series of string algorithms in Julia, including:

- Manacher's Algorithm
- Prefix Function & Prefix Automaton
- Z Algorithm
- Suffix AutoMaton (SAM)
  - Find number of occurrences of a pattern (`Base.count`)
  - Find the first occurrence of a pattern (`Base.findfirst`)
  - Find all occurrences of a pattern (`Base.findall`)
  - Longest common substring (of two or more strings/vectors)
  - Minimum/Maximum rotation
- Palindromic AutoMaton (PAM)
