struct MoonType <: abstractNaturalSatellite end 
Moon = NaturalSatellite(MoonType)

#Data, as previously used in AstroDynBase
mu(::Type{MoonType}) = 4902.80007
j2(::Type{MoonType}) = 203.21568e-6
mean_radius(::Type{MoonType}) = 1737.4
equatorial_radius(::Type{MoonType}) = 1737.4
polar_radius(::Type{MoonType}) = 1737.4

naif_id(::Type{MoonType}) = 301
parent(::Type{MoonType}) = EarthMoonBarycenter
frame(::Type{MoonType}) = "IAU_MOON"