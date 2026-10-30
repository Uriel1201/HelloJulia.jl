#=
The Thue–Morse sequence is an infinite sequence of 0s and 1s that is constructed by starting with 0 
and successively appending the bitwise negation (interchange 0s and 1s) of the existing sequence.
0
01
0110
01101001
0110100110010110
Write a program introcs/thuemorse.jl that takes an integer command-line argument n and prints an n-by-n pattern
by printing a + (plus sign) in row i and column j if bits i and j in the sequence are equal, 
and a - (minus sign) if they are different.
Include two space characters between each + and - character.

Hint:
p(i) == p(j)  ⇔  p(i ^ j) == 0  
Such that p(x) is the value of Thue-Morse in the position x, starting the sequence in zero.
And the operator ^ is the logical operator XOR
p(x) = x.count_ones() % 2 

Usage (Julia REPL): returns the data as values
julia> include("introcs/thuemorse.jl")
julia> showmatrix(thuemorse(700))
=#

function indexones(n::Int)::Matrix{Int}
    idx = collect(0:n-1)
    count_ones.(idx .⊻ idx')
end

function thuemorse(n::Int)::BitMatrix
    mod.(indexones(n), 2) .== 0
end

function showmatrix(thuemorse::BitMatrix)::Nothing 
    for row in eachrow(thuemorse)
        println(join(x ? "+  " : "-  " for x in row))
    end
end
