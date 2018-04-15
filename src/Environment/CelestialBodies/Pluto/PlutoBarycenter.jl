struct PlutoBarycenter <: abstractBarycenter end

naif_id(::Type{PlutoBarycenter}) = 9
parent(::Type{PlutoBarycenter}) = SSB