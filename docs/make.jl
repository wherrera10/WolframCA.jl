using Documenter, WolframCA


makedocs(
    sitename = "WolframCA Module Documentation",
    format = Documenter.HTML(prettyurls = false),
)

deploydocs(
    repo = "github.com/wherrera10/WolframCA.jl.git",
    devbranch = "master",  
)
