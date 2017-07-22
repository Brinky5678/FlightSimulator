#Expo Atmoshpere parameters
function GetExpoAtmosPrms()
  ρ0 = 1.225 #kg/m^3
  R = 287 #J/Kg K For Earth Air
  γ = 1.4 #For Earth Air
  g0 = 9.81#Float64(mu_earth)/Float64(rad_earth)^2
  H_s = 7125 #m
  T = H_s*g0/R
  a = sqrt(γ*R*T)
  return AtmosPrms = [ρ0, R, γ, g0, H_s, T, a]
end


function ExpoAtmos(PosRsph::Vector{Float64}, planetvars::Vector{Any},
                    AtmosPrms::Vector{Any}, t::Number)
  AltitudeFunction = planetvars[6]
  h = AltitudeFunction(PosRsph, planetvars)
  ρ = ρ0*exp(-h/H_s)
  p = ρ*R*T
  return [ρ, p, T, a]
end
