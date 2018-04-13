struct MarsBarycenter <: abstractBarycenter end 

naif_id(::Type{MarsBarycenter}) = 4
parent(::Type{MarsBarycenter}) = SSB