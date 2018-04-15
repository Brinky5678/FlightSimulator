#Define SunType and object
struct SunType <: abstractStar end 
Sun = Star(SunType)

#Data, as previously used in AstroDynBase
naif_id(::Type{SunType}) = 10
mu(::Type{SunType}) = 1.32712440041e11
mean_radius(::Type{SunType}) = 696000.0
polar_radius(::Type{SunType}) = 696000.0
equatorial_radius(::Type{SunType}) = 696000.0
parent(::Type{SunType}) = SSB

#Extra data
alpha(::Type{SunType}) = deg2rad.([286.13, 0., 0.])
delta(::Type{SunType}) = deg2rad.([63.87, 0., 0.])
omega(::Type{SunType}) = deg2rad.([84.176, 14.18440, 0.])

alpha_nut_prec(::Type{SunType}) = 0.
delta_nut_prec(::Type{SunType}) = 0.
omega_nut_prec(::Type{SunType}) = 0.  
theta0_nut_prec(::Type{SunType}) = 0.   
theta1_nut_prec(::Type{SunType}) = 0.

