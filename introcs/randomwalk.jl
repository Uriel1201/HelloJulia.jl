#=
Write a program introcs/randomwalk.jl that takes an integer command-line argument r
and simulates the motion of a random walk until the random walker is at Manhattan distance r
from the starting point.

~/HelloJulia.jl $ julia --project=. introcs/randomwalk.jl
=#
using Random
using Arrow

function randomwalk(manhattan::Int,
    rng::AbstractRNG
)::Vector{Tuple{Int64, Int64}}
    i = j = 0
    steps = [(0, 0)]
    while abs(i) + abs(j) < manhattan
        p = rand(rng)
        if p < 0.25
            i+=1
        elseif p < 0.5
            i -= 1
        elseif p < 0.75
            j += 1
        else
            j -= 1
        end
        push!(steps, (i, j))
    end
    steps
end

function main()
    if isempty(ARGS)
        println(stderr, "Usage randomwalk.jl: manhattan")
        exit(1)
    end
    manhattan = parse(Int, ARGS[1])
    if manhattan < 0
        println(stderr, "Error: manhattan must be positive")
        exit(1)
    end
    steps = randomwalk(manhattan, Random.default_rng())
    x     = map(first, steps)
    y     = map(last, steps)
    io    = IOBuffer()
    Arrow.write(io, (X_STEPS = x, Y_STEPS = y))
    write(stdout, take!(io))
    flush(stdout)
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    main()
end
