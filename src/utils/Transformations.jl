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