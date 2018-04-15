struct EarthType <: abstractPlanet end 
Earth = Planet(EarthType)

#Data, as previously used in AstroDynBase
mu(::Type{EarthType}) = 3.986004418e5 #km^3/s^2
j2(::Type{EarthType}) = 1.08262668e-3
j3(::Type{EarthType}) = -2.532e-6
j4(::Type{EarthType}) = -1.61e-6
mean_radius(::Type{EarthType}) = 6371.0084
equatorial_radius(::Type{EarthType}) = 6378.1366
polar_radius(::Type{EarthType}) = 6356.7519

naif_id(::Type{EarthType}) = 399
parent(::Type{EarthType}) = EarthMoonBarycenter
frame(::Type{EarthType}) = "IAU_EARTH"