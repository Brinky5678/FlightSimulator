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
frame(::Type{VenusType}) = "IAU_VENUS"