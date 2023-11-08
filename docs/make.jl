using Experiments
using Documenter

DocMeta.setdocmeta!(Experiments, :DocTestSetup, :(using Experiments); recursive=true)

makedocs(;
    modules=[Experiments],
    authors="Fabian Müller",
    repo="https://github.com/dfabianus/Experiments.jl/blob/{commit}{path}#{line}",
    sitename="Experiments.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://dfabianus.github.io/Experiments.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/dfabianus/Experiments.jl",
    devbranch="master",
)
