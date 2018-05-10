function CentralGravity(Body::Type{<:abstractCelestialBody}, PosRsph::Vector{Float64})
  #This function computes the gravitational acceleration according to a Central
  #field model. Gravitational acceleration written in V-frame
  return g = [0, 0, GM(Body)/PosRsph[1]^2]
end
