
function CentralGravity(PosRsph::Vector{Float64}, planetvars::Vector{Any})
  #This function computes the gravitational acceleration according to a Central
  #field model. Gravitational acceleration written in V-frame
  return g = [0, 0, planetvars[2]/PosRsph[1]^2]
end
