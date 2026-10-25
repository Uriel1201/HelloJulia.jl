#=
Name: Dante1201 (Carlos Uriel García)
Id:   1201

Write a program introcs/birthday.jl that takes two integer command-line arguments n
and trials and performs the following experiment, trials times:

- Choose a birthday for the next person, uniformly at random between 1 and n.
- Have that person enter the room.
- If that person shares a birthday with someone else in the room, stop; otherwise repeat.

In each experiment, count the number of people that enter the room.
Print a table that summarizes the results (the count i, the number of times that
exactly i people enter the room, and the fraction of times that i or fewer people enter the room)
for each possible value of i from 1 until the fraction reaches (or exceeds) 50%.

~/HelloJulia.jl$ julia --project=. introcs/birthday.jl 365 1000000
=#

using Random
using Arrow

function birthdaysimulation(n::Int64, trials::Int64)::Vector{Int64}
    n > 0 || throw(ArgumentError("n must be positive"))
    trials >= 0 || throw(ArgumentError("trials must be non-negative"))
    s        = zeros(Int64, n + 1)
    rng      = Random.default_rng()
    birthday = falses(n)
    for _ in 1:trials
        fill!(birthday, false)
        count = 0
        for _ in 1:(n + 1)
            p = rand(rng, 1:n)
            count += 1
            birthday[p] && break
            birthday[p] = true
        end
        s[count] +=1
    end
    return s
end

function main()
    if length(ARGS) < 2
        println(stderr, "Error: Usage n, trials")
        exit(1)
    end
    n = parse(Int64, ARGS[1])
    trials = parse(Int64, ARGS[2])
    simulation = birthdaysimulation(n, trials)
    t = Float64(trials)
    f = cumsum(simulation) ./ t
    idx = findfirst(>=(0.5), p)
    if idx !== nothing
        f          = f[1:idx]
        simulation = simulation[1:idx]
        p          = p[1:idx]
    end
    io = IOBuffer()
    Arrow.write(io, (k = 1:length(simulation), count_k = simulation, p_k = f))
    write(stdout, take!(io))
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    main()
end
