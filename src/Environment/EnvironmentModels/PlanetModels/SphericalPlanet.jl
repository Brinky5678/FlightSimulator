"""
```julia
h = SphericalAltitude(Body::T, PosRsph::Vector{Float64}) where {T <: abstractCelestialBody}
```
Computes the altitude above a spherical central body with radius Re.
"""
function SphericalAltitude(Body::Type{<:abstractCelestialBody}, PosRsph::Vector{Float64})
  return PosRsph[1] - mean_radius(Body)
end
