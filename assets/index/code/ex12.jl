# This file was generated, do not modify it. # hide
using Krylov
A = rand(5, 5)
opA = LinearOperator(A)
opAAT = opA + opA'
b = rand(5)
(x, stats) = minres(opAAT, b)
norm(b - opAAT * x)