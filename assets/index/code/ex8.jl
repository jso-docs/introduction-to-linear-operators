# This file was generated, do not modify it. # hide
try
  dft * v     # ERROR: expected Vector{Float64}
catch ex
  println("ex = $ex")
end