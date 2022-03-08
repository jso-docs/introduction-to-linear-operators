# This file was generated, do not modify it.

using LinearOperators, SparseArrays
A1 = rand(5,7)
A2 = sprand(7,3,.3)
op1 = LinearOperator(A1)
op2 = LinearOperator(A2)
op = op1 * op2  # Does not form A1 * A2
x = rand(3)
y = op * x

using LinearAlgebra
A = rand(5,5)
A = A' * A
op = opCholesky(A)  # Use, e.g., as a preconditioner
v = rand(5)
norm(A \ v - op * v) / norm(v)

using LinearOperators, LinearAlgebra # hide
m, n = 50, 30
A = rand(m, n) + im * rand(m, n)
op = LinearOperator(A)
v = rand(n)
res = zeros(eltype(A), m)
res2 = copy(res)
mul!(res2, op, v) # compile 3-args mul!
al = @allocated mul!(res, op, v) # op * v, store result in res
println("Allocation of LinearOperator mul! product = $al")
v = rand(n)
α, β = 2.0, 3.0
mul!(res2, op, v, α, β) # compile 5-args mul!
al = @allocated mul!(res, op, v, α, β) # α * op * v + β * res, store result in res
println("Allocation of LinearOperator mul! product = $al")

using FFTW
function mulfft!(res, v, α, β)
  if β == 0
    res .= α .* fft(v)
  else
    res .= α .* fft(v) .+ β .* res
  end
end
function mulifft!(res, w, α, β)
  if β == 0
    res .= α .* ifft(w)
  else
    res .= α .* ifft(w) .+ β .* res
  end
end
dft = LinearOperator(ComplexF64, 10, 10, false, false,
                     mulfft!,
                     nothing,       # will be inferred
                     mulifft!)
x = rand(10)
y = dft * x
norm(dft' * y - x)  # DFT is a unitary operator

transpose(dft) * y

function customfunc!(res, v, α, β)
  if β == 0
    res[1] = (v[1] + v[2]) * α
    res[2] = v[2] * α
  else
    res[1] = (v[1] + v[2]) * α + res[1] * β
    res[2] = v[2] * α + res[2] * β
  end
end
function tcustomfunc!(res, w, α, β)
  if β == 0
    res[1] = w[1] * α
    res[2] =  (w[1] + w[2]) * α
  else
    res[1] = w[1] * α + res[1] * β
    res[2] =  (w[1] + w[2]) * α + res[2] * β
  end
end
op = LinearOperator(Float64, 2, 2, false, false,
                    customfunc!,
                    nothing,
                    tcustomfunc!)

op2 = LinearOperator(Float64, 2, 2, false, false,
                     (res, v) -> customfunc!(res, v, 1.0, 0.),
                     nothing,
                     (res, w) -> tcustomfunc!(res, w, 1.0, 0.))

res, a = zeros(2), rand(2)
mul!(res, op2, a) # compile
println("allocations 1st call = ", @allocated mul!(res, op2, a, 2.0, 3.0))
println("allocations 2nd call = ", @allocated mul!(res, op2, a, 2.0, 3.0))

using LinearOperators, FFTW # hide
dft = LinearOperator(Float64, 10, 10, false, false,
                     mulfft!,
                     nothing,
                     mulifft!)
v = rand(10)
println("eltype(dft)         = $(eltype(dft))")
println("eltype(v)           = $(eltype(v))")

try
  dft * v     # ERROR: expected Vector{Float64}
catch ex
  println("ex = $ex")
end

try
  Matrix(dft) # ERROR: tried to create a Matrix of Float64
catch ex
  println("ex = $ex")
end

# Using external modules

using Krylov
A = rand(5, 5)
opA = LinearOperator(A)
opAAT = opA + opA'
b = rand(5)
(x, stats) = minres(opAAT, b)
norm(b - opAAT * x)

B = LBFGSOperator(20)
H = InverseLBFGSOperator(20)
r = 0.0
for i = 1:100
  global r
  s = rand(20)
  y = rand(20)
  push!(B, s, y)
  push!(H, s, y)
  r += norm(B * H * s - s)
end
r

v = collect(1:5)
R = opRestriction([2;5], 5)
R * v

Matrix(R)

v = collect(1:2)
E = opExtension([2;5], 5)
E * v

A = rand(5,5)
opA = LinearOperator(A)
I = [1;3;5]
J = 2:4
A[I,J] * ones(3)

opRestriction(I, 5) * opA * opExtension(J, 5) * ones(3)

opA[1,:] * ones(5)

opA[:,1] * ones(1)

opA[1,1] * ones(1)

