struct MercuryBarycenter <: abstractBarycenter end 

naif_id(::Type{MercuryBarycenter}) = 1
parent(::Type{MercuryBarycenter}) = SSB