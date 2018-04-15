struct SaturnBarycenter <: abstractBarycenter end 

naif_id(::Type{SaturnBarycenter}) = 6
parent(::Type{SaturnBarycenter}) = SSB