function J2Gravity(Body::T, PosRsph::Vector{Float64}) where {T <: abstractCelestialBody}
  #Convert δ (latitude) into co-latitude α
  α = pi/2 - PosRsph[3];
  Re_r = mean_radius(Body)/PosRsph[1]
  J2planet = j2(Body)
  muplanet = mu(Body)

  #Gravity Field Terms
  g = zeros(3)
  g[3] = -muplanet/PosRsph[1]^2*(1- 1.5*J2planet*Re_r^2*(3*cos(α)^2 - 1))
  g[2] = 0.0
  g[1] = -(3*muplanet/PosRsph[1]^2*Re_r^2*sin(α)*cos(α)*(g[3] + J2planet))
  return g
end
