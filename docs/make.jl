using StringAlgorithms
using Documenter

DocMeta.setdocmeta!(StringAlgorithms, :DocTestSetup, :(using StringAlgorithms); recursive=true)

makedocs(;
    modules=[StringAlgorithms],
    authors="Gabriel Wu <wuzihua@pku.edu.cn> and contributors",
    repo="https://github.com/lucifer1004/StringAlgorithms.jl/blob/{commit}{path}#{line}",
    sitename="StringAlgorithms.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://lucifer1004.github.io/StringAlgorithms.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/lucifer1004/StringAlgorithms.jl",
    devbranch="main",
)
