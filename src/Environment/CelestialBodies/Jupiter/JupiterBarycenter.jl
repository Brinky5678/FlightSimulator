struct JupiterBarycenter <: abstractBarycenter end 

naif_id(::Type{JupiterBarycenter}) = 5
parent(::Type{JupiterBarycenter}) = SSB