struct EarthMoonBarycenter <: abstractBarycenter end 

naif_id(::Type{EarthMoonBarycenter}) = 3
parent(::Type{EarthMoonBarycenter}) = SSB