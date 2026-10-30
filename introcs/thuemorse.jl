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

Usage (Julia REPL): returns the data as values
julia> include("introcs/thuemorse.jl")
julia> 
=#
