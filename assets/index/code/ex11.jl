# This file was generated, do not modify it. # hide
try
  Matrix(dft) # ERROR: tried to create a Matrix of Float64
catch ex
  println("ex = $ex")
end

# Using external modules