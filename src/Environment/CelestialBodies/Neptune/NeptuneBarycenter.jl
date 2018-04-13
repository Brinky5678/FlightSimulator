struct NeptuneBarycenter <: abstractBarycenter end 

naif_id(::Type{NeptuneBarycenter}) = 8
parent(::Type{NeptuneBarycenter}) = SSB 