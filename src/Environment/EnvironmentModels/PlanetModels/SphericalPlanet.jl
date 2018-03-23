"""
```julia
h = SphericalAltitude(Body::Type{<:CelestialBody}, PosRsph::Vector{Float64})
```
Computes the altitude above a spherical central body with radius Re.
"""
function SphericalAltitude(Body::T, PosRsph::Vector{Float64}) where {T <: abstractCelestialBody}
  return PosRsph[1] - mean_radius(Body)
end
