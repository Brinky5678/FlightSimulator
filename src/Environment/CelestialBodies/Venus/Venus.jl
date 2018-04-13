struct VenusType <: abstractPlanet end 
Venus = Planet(VenusType)

#Data, as previously used in AstroDynBase
mu(::Type{VenusType}) = 3.24859e5
j2(::Type{VenusType}) = 6e-5
mean_radius(::Type{VenusType}) = 6051.8
equatorial_radius(::Type{VenusType}) = 6051.8
polar_radius(::Type{VenusType}) = 6051.8

naif_id(::Type{VenusType}) = 299
parent(::Type{VenusType}) = VenusBarycenter

#Extra Data 
alpha(::Type{VenusType}) = deg2rad.([272.76, 0., 0.])
delta(::Type{VenusType}) = deg2rad.([67.16, 0., 0.])
omega(::Type{VenusType}) = deg2rad.([160.20, -1.4813688, 0.])

alpha_nut_prec(::Type{VenusType}) = 0.
delta_nut_prec(::Type{VenusType}) = 0.
omega_nut_prec(::Type{VenusType}) = 0. 
theta0_nut_prec(::Type{VenusType}) = 0.    
theta1_nut_prec(::Type{VenusType}) = 0.