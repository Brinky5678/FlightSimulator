struct VenusBarycenter <: abstractBarycenter end 

naif_id(::Type{VenusBarycenter}) = 2
parent(::Type{VenusBarycenter}) = SSB