#=
Name: Dante1201 (Carlos Uriel García)
Id:   1201

Write a program introcs/discretedistribution.jl that takes an integer command-line
argument m, followed by a sequence of positive integer command-line arguments a1,a2,…,an
and prints m random indices choosing each index i with probability proportional to ai.

~/HelloJulia.jl $ julia --project=. introcs/discretedistribution.jl 20 100 200 50 90 120 300 90
=#
using Random
using Arrow

function discretedistribution(size::Int, lengths::Vector{Int})::Vector{Int}
    rng = Random.default_rng()
    s   = cumsum(lengths)
    p   = rand(rng, 1:s[end], size)
    return searchsortedfirst.(Ref(s), p)
end

function main()
    if length(ARGS) < 2
        println(stderr, "Error: Usage size, lengths")
        exit(1)
    end
    size = parse(Int, ARGS[1])
    if size < 0
        println(stderr, "Error: size must be non-negative")
        exit(1)
    end
    lengths = parse.(Int, ARGS[2:end])
    if sum(lengths) == 0
        println(stderr, "Error: cumulative must be positive")
        exit(1)
    end
    sample = discretedistribution(size, lengths)
    io     = IOBuffer()
    Arrow.write(io, (sample = sample,))
    write(stdout, take!(io))
    flush(stdout)
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    main()
end
