import AstroDynBase
#Define Mercury type and object
struct MercuryType <: abstractPlanet end 
Mercury = Planet(MercuryType)

#Data, as previously used in AstroDynBase
mu(::Type{MercuryType}) = 2.2032e4 #km^3/s^2
j2(::Type{MercuryType}) = 2.027e-4
mean_radius(::Type{MercuryType}) = 2439.7
equatorial_radius(::Type{MercuryType}) = 2439.7
polar_radius(::Type{MercuryType}) = 2439.7

naif_id(::Type{MercuryType}) = 199
parent(::Type{MercuryType}) = MercuryBarycenter
frame(::Type{MercuryType}) = "IAU_MERCURY"