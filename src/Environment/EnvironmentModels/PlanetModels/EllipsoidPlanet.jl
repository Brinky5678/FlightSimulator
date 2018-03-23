"""
```julia
h = EllipsoidAltitude(Body::Type{<:CelestialBody}, PosRsph::Vector{Float64})
```
Computes the altitude above the reference ellipsoid with equatorial radius `Re`,
and a flattening `flat`.
"""

function EllipsoidAltitude(Body::Type{<:CelestialBody}, PosRsph::Vector{Float64})
  return PosRsph[1] - equatorial_radius(Body)*(1-flattening(Body)*sin(PosRsph[3])^2)
end
