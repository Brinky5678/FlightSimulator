"""
```julia
Q_I2R(theta::T) where {T <: Real}
```
Computes the transformation Quaternion from the I-frame to the R-frame using the
Greenwich Hour Angle in radians.
"""
function Q_I2R(theta::T) where {T <: Real}
  return angleaxis2quat(theta, [0,0,1])
end

"""
```julia
Q_R2I(theta::T) where {T <: Real}
```
Computes the transformation Quaternion from the R-frame to the I-frame using the
Greenwich Hour Angle in radians.
"""
function Q_R2I(theta::T) where {T <: Real}
  return angleaxis2quat(-theta, [0,0,1])
end

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

"""
```julia
Q_V2I(theta::T, tau::B, delta::C) where {T,B,C <: Real}
```
Computes the transformation Quaternion from the V-frame to the I-frame.
"""
function Q_V2I(theta::T, tau::B, delta::C) where {T,B,C <: Real}
    return Q_V2R(tau, delta)*Q_R2I(theta)
end 

"""
```julia
Q_I2V(theta::T, tau::B, delta::C) where {T,B,C <: Real}
```
Computes the transformation Quaternion from the I-frame to the V-frame.
"""
function Q_I2V(theta::T, tau::B, delta::C) where {T,B,C <: Real}
    return inverse(Q_V2I(theta,tau,delta))
end 


warn("The Q_V2B transformation has to be redone with the correct simulation state vector")
"""
```julia
Q_V2B(VehState::Vector{Float64}, GMST::Float64)
```
Computes the transformation matrix from the V-frame to the B-frame, using the
vehicle state and the GMST as inputs.
"""
#=
function Q_V2B(VehState::Vector{T}, GMST::S) where {T,S <: Real}
  QI2R = Q_I2R(GMST)
  PosSph = PositionCart2Sph(QI2R*VehState[4:6])
  return inverse(Quaternion(VehState[10],VehState[11:13]))*(QI2R*Q_R2V(PosSph[2], PosSph[3])))
end
=#