#=
Write a program introcs/randomwalk.jl that takes an integer command-line argument r and simulates the motion of a random walk 
until the random walker is at Manhattan distance r from the starting point. 
Print the coordinates at each step of the walk (including the starting and ending points), treating the starting point as (0, 0). 
Also, print the total number of steps taken.

Usage (terminal): emits an Arrow stream on stdout, consumed by a plotting script:
~/HelloJulia.jl $ julia --project=. introcs/randomwalk.jl 250 | uv run --script ../HELLO_PLOTS/plot_dist.py

Usage (Julia REPL): returns the data as values:
julia> using DataFrames, Random
julia> include("introcs/discretedistribution.jl")
julia> df = DataFrame(discretedistribution(250, Random.default_rng()); copycols=false)
julia> println("TOTAL_STEPS: $(nrow(df))")
=#
using Random
using Arrow

function randomwalk(manhattan::Int,
    rng::AbstractRNG
)::@NamedTuple{STEP_X::Vector{Int}, STEP_Y::Vector{Int}}
    i = j = 0
    steps = (STEP_X = Int[0], STEP_Y = Int[0])
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
        push!(steps.STEP_X, i)
        push!(steps.STEP_Y, j)
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
    io    = IOBuffer()
    Arrow.write(io, steps)
    write(stdout, take!(io))
    flush(stdout)
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    main()
end
