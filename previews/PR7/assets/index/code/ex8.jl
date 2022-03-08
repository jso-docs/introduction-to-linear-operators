# This file was generated, do not modify it. # hide
res, a = zeros(2), rand(2)
mul!(res, op2, a) # compile
println("allocations 1st call = ", @allocated mul!(res, op2, a, 2.0, 3.0))
println("allocations 2nd call = ", @allocated mul!(res, op2, a, 2.0, 3.0))