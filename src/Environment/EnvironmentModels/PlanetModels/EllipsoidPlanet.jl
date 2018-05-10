"""
```julia
h = EllipsoidAltitude(Body::T, PosRsph::Vector{Float64}) where {T <: abstractCelestialBody}
```
Computes the altitude above the reference ellipsoid with equatorial radius `Re`,
and a flattening `flat`.
"""

function EllipsoidAltitude(Body::Type{<:abstractCelestialBody}, PosRsph::Vector{Float64})
  return PosRsph[1] - equatorial_radius(Body)*(1-flattening(Body)*sin(PosRsph[3])^2)
end
