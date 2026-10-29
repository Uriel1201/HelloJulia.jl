#=
Name: Dante1201 (Carlos Uriel García)
Id:   1201

Write a program introcs/discretedistribution.jl that takes an integer command-line
argument m, followed by a sequence of positive integer command-line arguments a1,a2,…,an
and prints m random indices choosing each index i with probability proportional to ai.

Usage (terminal): emits an Arrow stream on stdout, consumed by a plotting script
~/HelloJulia.jl $ julia --project=. introcs/discretedistribution.jl 1000000 20 30 20 45 70 300 120 | uv run --script ../HELLO_PLOTS/plot_birthday.py

Usage (Julia REPL): returns the data as values
julia> using DataFrames
julia> include("introcs/discretedistribution.jl")
julia> df = DataFrame(discreteDistribution(1000000, cumsum[20, 30, 20, 45, 70, 300, 120]); copycols=false)
=#
using Random
using Arrow

function discretedistribution(size::Int, cumweights::Vector{Int}, rng::AbstractRNG)::Vector{Int}
    p = rand(rng, 1:cumweights[end], size)
    return searchsortedfirst.(Ref(cumweights), p)
end

function main()
    if length(ARGS) < 2
        println(stderr, "Usage: discretedistribution.jl m a1 a2 ... an")
        exit(1)
    end
    m          = parse(Int, ARGS[1])
    if m < 0
        println(stderr, "Error: m must be non-negative")
        exit(1)
    end
    weights    = parse.(Int, ARGS[2:end])
    if !all(>(0), weights)
        println(stderr, "Error: weights must be positive")
        exit(1)
    end
    rng        = Random.default_rng()
    cumweights = cumsum(weights)
    sample     = discretedistribution(m, cumweights, rng)
    io         = IOBuffer()
    Arrow.write(io, (sample = sample,))
    write(stdout, take!(io))
    flush(stdout)
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    main()
end
