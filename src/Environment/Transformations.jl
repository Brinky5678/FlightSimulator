"""
```julia
Q_R2V(tau::T, delta::S) where {T,S <: Real}
```
Computes the transformation Quaternion from the R-frame to the V-frame.
"""
function Q_R2V(tau::T, delta::S) where {T,S <: Real}
  return inverse(Q_V2R(tau, delta))
end

"""
```julia
Q_V2R(tau::T, delta::S) where {T,S <: Real}
```
Computes the transformation Quaternion from the V-frame to the R-frame.
"""
function Q_V2R(tau::T, delta::S) where {T,S <: Real}
  return angleaxis2quat(pi/2 + delta,[0,1,0])*angleaxis2quat(-tau,[0,0,1])
end

#=
warn("The Q_V2B transformation has to be redone with the correct simulation state vector")
"""
```julia
Q_V2B(VehState::Vector{Float64}, GMST::Float64)
```
Computes the transformation matrix from the V-frame to the B-frame, using the
vehicle state and the GMST as inputs.
"""
function Q_V2B(VehState::Vector{T}, GMST::S) where {T,S <: Real}
  QI2R = Q_I2R(GMST)
  PosSph = PositionCart2Sph(QI2R*VehState[4:6])
  return inverse(Quaternion(VehState[10],VehState[11:13]))*(QI2R*Q_R2V(PosSph[2], PosSph[3])))
end
=#

"""
```julia
[V_air, γ, χ] = VelocityCart2Sph(VelCart::Vector{Float64})
```
Computes the spherical velocity components from its cartesian counterparts (
  in V-frame ).
"""
function VelocityCart2Sph(VelCart::Vector{T}) where {T <: Real}
  Va = norm(VelCart)
  if Va < 1e-13
    return 0, 0, 0
  else
    return [Va -asin(VelCart[3]/Va) atan2(VelCart[2], VelCart[1])]
  end
end

"""
```julia
[R, τ, δ] = PositionCart2Sph(PosCart::Vector{Float64})
```
Computes the spherical position from its cartesian components.
"""
function PositionCart2Sph(PosCart::Vector{T}) where {T <: Real}
  return [norm(PosCart), atan2(PosCart[2], PosCart[1]),
    asin(PosCart[3]/norm(PosCart))]
end

"""
```julia
PosCart = PositionSph2Cart(PosSph::Vector{Float64})
```
Computes the cartesian position from its spherical components.
"""
function PositionSph2Cart(PosSph::Vector{T}) where {T <: Real}
  return PosSph[1].*[cos(PosSph[3])*cos(PosSph[2]) cos(PosSph[3])*sin(PosSph[2])
    sin(PosSph[2])]
end

"""
```julia
[VA, γ_a, χ_a], Q_V2TA =
  AirVelocity(VG_NED::Vector{Float64}, VW_NED::Vector{Float64} = zeros(3))
```
Computes the airspeed, flight path angle, the heading, and the vertical to
airspeed based trajectory reference frame transformation matrix.
"""
function AirVelocity(VG_NED::Vector{T}, VW_NED::Vector{S} = [0,0,0]) where {T,S <: Real}
  VA_NED = VG_NED - VW_NED
  VA = norm(VA_NED)
  if VA < eps()
    γ_a = χ_a = 0
  else
    γ_a = -asin(VA_NED[3]/VA)
    χ_a = atan2(VA_NED[2], VA_NED[1])
  end
  return [VA, γ_a, χ_a], Q_V2TA(γ_a, χ_a)
end