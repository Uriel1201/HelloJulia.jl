#=
Name: Dante1201 (Carlos Uriel García)
Id:   1201

Write a program introcs/random_walkers.jl that takes two integer command-line arguments r and trials.
In each of trials independent experiments, simulate a random walk
until the random walker is at Manhattan distance r from the starting point.
Print the average number of steps.

julia> run(`bash -c "julia --project=. introcs/randomwalkers.jl 400 2000000"`)
=#
using Random
using Arrow

function randomwalk(manhattan::Int,
    rng::AbstractRNG
)::Int
    i     = 0
    j     = 0
    steps = 0
    while abs(i) + abs(j) < manhattan
        p = rand(rng)
        if p < 0.25
            i += 1
        elseif p < 0.5
            i -= 1
        elseif p < 0.75
            j += 1
        else
            j -= 1
        end
        steps += 1
    end
    steps
end

function randomwalkers(manhattan::Int,
    trials::Int,
    rng::AbstractRNG
)::Vector{Int}
    v = Vector{Int}(undef, trials)
    for t in 1:trials
        v[t] = randomwalk(manhattan, rng)
    end
    v
end

function main()
    if isempty(ARGS)
        println(stderr, "Error randomwalkers.jl: expected manhattan, trials")
        exit(1)
    end
    manhattan = parse(Int, ARGS[1])
    trials    = parse(Int, ARGS[2])
    if manhattan <= 0 || trials <= 0
        println(stderr, "Error: expected positive arguments")
        exit(1)
    end
    rng       = Random.default_rng()
    steps     = randomwalkers(manhattan, trials, rng)
    obs       = 1:trials
    means     = cumsum(steps) ./ obs
    io        = IOBuffer()
    Arrow.write(io, (OBS = obs, SAMPLE = steps, SAMPLE_MEANS = means))
    write(stdout, take!(io))
    flush(stdout)
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    main()
end
