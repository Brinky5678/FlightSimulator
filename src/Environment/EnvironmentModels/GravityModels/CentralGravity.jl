function CentralGravity(Body::T, PosRsph::Vector{Float64}) where {T <: abstractCelestialBody}
  #This function computes the gravitational acceleration according to a Central
  #field model. Gravitational acceleration written in V-frame
  return g = [0, 0, mu(Body)/PosRsph[1]^2]
end
