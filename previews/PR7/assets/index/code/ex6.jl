# This file was generated, do not modify it. # hide
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