struct UranusBarycenter <: abstractBarycenter end 

naif_id(::Type{UranusBarycenter}) = 7
parent(::Type{UranusBarycenter}) = SSB