"""
```julia
C_R2V(tau::Float64, delta::Float64)
```
Computes the transformation matrix from the R-frame to the V-frame.
"""
function C_R2V(tau::Float64, delta::Float64)
  return [[-sin(delta)*cos(tau) -sin(delta)*sin(tau) cos(delta)];
         [-sin(tau) cos(tau) 0];
         [-cos(delta)*cos(tau) -cos(delta)*sin(tau) -sin(delta)]]
end

"""
```julia
C_V2R(tau::Float64, delta::Float64)
```
Computes the transformation matrix from the V-frame to the R-frame.
"""
function C_V2R(tau::Float64, delta::Float64)
  return [[-sin(delta)*cos(tau) -sin(tau) -cos(delta)*cos(tau)];
          [-sin(delta)*sin(tau) cos(tau) -cos(delta)*sin(tau)];
          [cos(delta) 0 -sin(delta)]]
end

"""
```julia
C_I2R(theta::Float64)
```
Computes the transformation matrix from the I-frame to the R-frame using the
Greenwich Hour Angle in radians.
"""
function C_I2R(theta::Float64)
  return [[cos(theta) sin(theta) 0];
         [-sin(theta) cos(theta) 0];
         [0 0 1]]
end

"""
```julia
C_R2I(theta::Float64)
```
Computes the transformation matrix from the R-frame to the I-frame using the
Greenwich Hour Angle in radians.
"""
function C_R2I(theta::Float64)
  return C_I2R(-theta)
end

"""
```julia
C_V2I(GMST::T, tau::B, delta::B) where {T <: Real, B <: Real}
```
Computes the transformation matrix from the V-frame to the I-frame using the
Greenwich Hour Angle in radians, and the longitude and latitude in radians.
"""
function C_V2I(GMST::T, tau::B, delta::B) where {T <: Real, B <: Real}
  return C_V2R(tau, delta)*C_R2I(GMST)
end 

"""
```julia
VelR = VelocityI2R(VelI::Vector{Float64}, PosI::Vector{Float64}, ω::Float64,
  CI2R::Array{Float64}(3,3))
```
Computes the velocity vector in the R-frame from the I-frame.
"""
function VelocityI2R(VelI::Vector{T}, PosI::Vector{P}, ω::S, CI2R::Array{R,2}) where {T,P,S,R <: Real}
  return CI2R*(VelI + [ω*PosI[2], -ω*PosI[1], 0])
end

"""
```julia
PosR = PositionI2R(PosI::Vector{Float64}, CI2R::Array{Float64}(3,3))
```
Computes the position vector in the R-frame from the I-frame.
"""
function PositionI2R(PosI::Vector{Float64}, CI2R::Array{Float64,2})
  return CI2R*PosI
end

"""
```julia
C_V2B(VehState::Vector{Float64}, GMST::Float64)
```
Computes the transformation matrix from the V-frame to the B-frame, using the
vehicle state and the GMST as inputs.
"""
function C_V2B(VehState::Vector{Float64}, GMST::Float64)
  CI2R = C_I2R(GMST)
  PosSph = PositionCart2Sph(CI2R*VehState[4:6])
  return transpose(C_B2I(VehState[10:13])*(CI2R*C_R2V(PosSph[2], PosSph[3])))
end

"""
```julia
function C_B2I(quatB2I::Vector{Float64})
```
Computes the transformation matrix from the B-frame to the I-frame, using the
the quaternion describing the same orientation.
"""
function C_B2I(quatB2I::Vector{Float64})
  return quat2DCM(quatB2I)
end

"""
```julia
C_B2V(VehState::Vector{Float64}, GMST::Float64)
```
Computes the transformation matrix from the B-frame to the V-frame, using the
vehicle state and the GMST as inputs.
"""
function C_B2V(VehState::Vector{Float64}, GMST::Float64)
  return transpose(C_V2B(VehState, GMST))
end

"""
```julia
C_V2TA(γ_a::Float64, χ_a::Float64)
```
Computes the transformation matrix from the V-frame to the airspeed based
trajectory frame.
"""
function C_V2TA(γ_a::T, χ_a::S) where {T,S <: Real}
  return [[cos(χ_a)*cos(γ_a) sin(χ_a)*cos(γ_a) -sin(γ_a)];
            [-sin(χ_a) cos(χ_a) 0.0];
            [cos(χ_a)*sin(γ_a) sin(χ_a)*sin(γ_a) cos(γ_a)]]
end

"""
```julia
C_B2TA(C_B2V::Array{Float64,2}, C_V2TA::Array{Float64,2})
```
Computes the transformation matrix from the B-frame to the airspeed based
trajectory frame.
"""
function C_B2TA(C_B2V::Array{Float64,2}, C_V2TA::Array{Float64,2})
  return C_B2V*C_V2TA
end

"""
```julia
[α, β, σ] =
  AirAttitude(C_B2V::Array{Float64,2}, C_V2TA::Array{Float64,2})
```
Computes the angle of attack, sideslip angle, bank angle, and the body to
airspeed based trajectory reference frame transformation matrix.
"""
function AirAttitude(C_B2V::Array{T,2}, C_V2TA::Array{S,2}) where {T,S <: Real}
  CB2TA = C_B2TA(C_B2V, C_V2TA)
  return [atan2(CB2TA[1,3],CB2TA[1,1]), asin(CB2TA[1,2]),
    atan2(-CB2TA[3,2], CB2TA[2,2])]
end

"""
```julia
C_B2AA(α::Float64, β::Float64)
```
Computes the transformation matrix from the B-frame to the airspeed based
aerodynamic frame
"""
function C_B2AA(α::Float64, β::Float64)
  return [[cos(α)*cos(β) sin(β) sin(α)*cos(β)];
          [-cos(α)*sin(β) cos(β) -sin(α)*sin(β)];
          [-sin(α) 0.0 cos(α)]]
end

"""
```julia
C_AA2B(α::Float64, β::Float64)
```
Computes the transformation matrix from the airspeed based
aerodynamic frame to the B-frame
"""
function C_AA2B(α::Float64, β::Float64)
  return transpose(C_B2AA(α,β))
end

#=
"""
```julia
PosRsph, C_AA2I, C_V2I, V_VA =
    TransformUtils(state::Vector{Float64}, simtime::Float64, ω::Float64 = 0.)
```
Computes the transformation matrix from the airspeed based
aerodynamic frame to the I-frame
"""
function TransformUtils(state::Vector{Float64}, simt::Float64, ω::Float64 = 0.)
  GMST = calc_GMST(MJD(simt))
  CI2R = C_I2R(GMST)
  VR = VelocityI2R(state[1:3], state[4:6], ω, CI2R)
  PosR = CI2R*state[4:6]
  PosRSph = PositionCart2Sph(PosR)
  CR2V = C_R2V(PosRSph[2], PosRSph[3])
  VV = CR2V*VR
  Vsph = VelocityCart2Sph(VV)
  Angles = AirAttitude(C_B2V(state, GMST), C_V2TA(Vsph[2], Vsph[3]))
  return PosRSph, C_B2I(state[10:13])*C_AA2B(Angles[1], Angles[2]), transpose(CI2R*CR2V),
            Vsph[1]
end
=#