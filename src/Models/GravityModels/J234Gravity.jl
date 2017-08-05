function J234Gravity(Body::Type{<:CelestialBody}, PosRsph::Vector{Float64})
  g = zeros(3)
  #Convert δ (latitude) into co-latitude α
  α = pi/2 - PosRsph[3];
  Re_r = mean_radius(Body)/PosRsph[1]
  J2planet = j2(Body)
  J3planet = j3(Body)
  J4planet = j4(Body)
  muplanet = mu(Body)
  R = PosRsph[1]
  #Division by zero check
  cos(α) == 0 ? sec_a = 1e20 : sec_a = 1/cos(α)
  #Fourth order correction
  g[1] += -5/8*J4planet*Re_r^4*(35*cos(α)^4 - 30*cos(α)^2 + 3)
  g[3] += 5/6*J4planet*Re_r^2*(7*cos(α)^2 - 1)
  #Third order correction
  g[1] += -2*J3planet*Re_r^3*cos(α)*(5*cos(α)^2 - 1)
  g[3] += 0.5*J3planet*Re_r*sec_a*(5*cos(α)^2 - 1)
  #Second order correction
  g[1] += -1.5*J2planet*Re_r^2*(3*cos(α)^2 - 1)
  g[3] = 3*muplanet/R^2*Re_r^2*sin(α)*cos(α)*(g[3] + J2planet)
  #Central field term
  g[1] = -muplanet/R^2*(1+g[1])
  #transform to V-frame
  return g = [-g[3], g[2], g[1]]
end
