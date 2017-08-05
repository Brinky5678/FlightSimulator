#Expo Atmoshpere parameters
 ρ0expo(::Type{Earth}) = 1.225 #kg/m^3
 Rexpo(::Type{Earth}) = 287 #J/Kg K For Earth Air
 γexpo(::Type{Earth}) = 1.4 #For Earth Air
 g0expo(::Type{Earth}) = mu(Earth)/equatorial_radius(Earth)^2*1000
 H_sexpo(::Type{Earth}) = 7125 #m
 Texpo(::Type{Earth}) = H_s*g0/R
 aexpo(::Type{Earth}) = sqrt(γ*R*T)

function ExpoAtmos(Body::Type{<:CelestialBody}, PosRsph::Vector{Float64})
  h = Altitude(Body, PosRsph)
  ρ = ρ0expo(Body)*exp(-h/H_sexpo(Body))
  p = ρ*Rexpo(Body)*Texpo(Body)
  return [ρ, p, Texpo(Body), aexpo(Body)]
end
