function J234Gravity(PosRsph::Vector{Float64}, planetvars::Vector{Any})
  g = zeros(3)

  #Convert δ (latitude) into co-latitude α
  α = pi/2 - PosRsph[3];
  Re_r = planetvars[1]/PosRsph[1]
  J2 = planetvars[5][1]
  J3 = planetvars[5][2]
  J4 = planetvars[5][3]
  mu = planetvars[2]

  cos(α) == 0 ? sec_a = 1e20 : sec_a = 1/cos(α)

  g[1] += -5/8*J4*Re_r^4*(35*cos(α)^4 - 30*cos(α)^2 + 3)
  g[3] += 5/6*J4*Re_r^2*(7*cos(α)^2 - 1)

  g[1] += -2*J3*Re_r^3*cos(α)*(5*cos(α)^2 - 1)
  g[3] += 0.5*J3*Re_r*sec_a*(5*cos(α)^2 - 1)

  g[1] += -1.5*J2*Re_r^2*(3*cos(α)^2 - 1)
  g[3] = 3*mu/R^2*Re_r^2*sin(α)*cos(α)*(g[3] + J2)

  #Central field term
  g[1] = -mu/R^2*(1+g[1])

  #transform to V-frame
  return g = [-g[3], g[2], g[1]]
  
end
