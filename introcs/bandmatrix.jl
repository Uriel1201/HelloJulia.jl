#=
Band Matrices.
Write a program introcs/bandmatrix.jl that takes two integer command-line arguments 
n and width and prints an n-by-n pattern, with a zero (0) for each element whose distance 
from the main diagonal is strictly more than width, and an asterisk (*) for each entry that is not,
and two spaces between each 0 or *.

Usage (Julia REPL): returns the data as values
julia> include("introcs/bandmatrix.jl")
julia> b = bandmatrix(27, 12)
julia> for row in eachrow(b)
           println(join(x ? "*  " : "0  " for x in row))
       end
=#

function indexmatrix(
    n::Int
)::Matrix{Int}
    abs.((1:n) .- (1:n)')
end

function bandmatrix(
    n::Int,
    width::Int
)::BitMatrix
    nxn  = indexmatrix(n)
    nxn .<= width 
end
