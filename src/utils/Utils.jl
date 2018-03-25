#Collection of utility functions
"""
```julia
  qdyn, M = Calc_Dynamic_Pressure(ρ::Float64, V_VA::Float64, ss::Float64)
```
Computes the dynamic pressure and local Mach Number from the air density,
the airspeed (in the V-frame), and the speed of sound.
"""
function Calc_Dynamic_Pressure(ρ::Float64, V_VA::Float64, ss::Float64)
  return 0.5*ρ*V_VA^2, V_VA/ss
end

"""
```julia
GMST(MJD::T) where {T <: Real}
```
This function computes the Greenwich Mean Sidereal Time and outputs it as an
angle (0..2pi).
"""
function GMST(MJD::T) where {T <: Real}
  MJD0 = floor(MJD)
  UT1 = SECS*(MJD - MJD0)
  T0 = (MJD0 - MJD_J2000) / JULIAN_CENTURY
  Tval = (MJD - MJD_J2000) / JULIAN_CENTURY  
  temp = (GMST_CONSTS[1] + GMST_CONSTS[2]*T0 + GMST_CONSTS[3]*Tval^2 - GMST_CONSTS[4]*Tval^3 + GMST_CONSTS[5]*UT1)/SECS
  return 2pi*(temp - floor(temp))
end

"""
```julia
GMST(dt::DateTime, simtime::T = 0.0) where {T <: Real}
```
This function computes the Greenwich Mean Sidereal Time and outputs it as an
angle (0..2pi).
"""
function GMST(dt::DateTime, simtime::T = 0.0) where {T <: Real}
  return GMST(datetime2modifiedjulian(dt, simtime))
end 

"""
```julia
datetime2modifiedjulian(dt::DateTime, simtime::Float64 = 0.0)
```
This function computes the Modified Julian Data from calender date and (optional) simulation time.
"""
function datetime2modifiedjulian(dt::DateTime, simtime::T = 0.0) where {T <: Real}
  if simtime != 0.0 
    #Extract seconds and milliseconds from the simulation time
    simseconds = floor(simtime)
    simmilliseconds = simtime - simseconds  
    #Create new DateTime Object
    dtnew = DateTime(Dates.Year(dt),Dates.Month(dt),Dates.Day(dt), Dates.Hour(dt), Dates.Minute(dt), 
      Dates.Second(dt) + Dates.Second(simseconds), Dates.Millisecond(dt) + Dates.Millisecond(simmilliseconds))
    return (Dates.datetime2julian(dtnew) - JD_TO_MJD)
  else
    return (Dates.datetime2julian(dt) - JD_TO_MJD)
  end
end 

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
[V_air, γ, χ] = VelocityCart2Sph(VelCart::Vector{Float64})
```
Computes the spherical velocity components from its cartesian counterparts (
  in V-frame ).
"""
function VelocityCart2Sph(VelCart::Vector{Float64})
  Va = norm(VelCart)
  if Va < 1e-13
    return 0, 0, 0
  else
    return [Va -asin(VelCart[3]/Va) atan2(VelCart[2], VelCart[1])]
  end
end

"""
```julia
VelR = VelocityI2R(VelI::Vector{Float64}, PosI::Vector{Float64}, ω::Float64,
  CI2R::Array{Float64}(3,3))
```
Computes the velocity vector in the R-frame from the I-frame.
"""
function VelocityI2R(VelI::Vector{Float64}, PosI::Vector{Float64}, ω::Float64,
    CI2R::Array{Float64,2})
  return CI2R*(VelI + [ω*PosI[2], -ω*PosI[1], 0])
end

"""
```julia
[R, τ, δ] = PositionCart2Sph(PosCart::Vector{Float64})
```
Computes the spherical position from its cartesian components.
"""
function PositionCart2Sph(PosCart::Vector{Float64})
  return [norm(PosCart), atan2(PosCart[2], PosCart[1]),
    atan2(PosCart[3], norm(PosCart))]
end

"""
```julia
PosCart = PositionSph2Cart(PosSph::Vector{Float64})
```
Computes the cartesian position from its spherical components.
"""
function PositionSph2Cart(PosSph::Vector{Float64})
  return PosSph[1].*[cos(PosSph[3])*cos(PosSph[2]) cos(PosSph[3])*sin(PosSph[2])
    sin(PosSph[2])]
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
[VA, γ_a, χ_a], C_V2TA =
  AirVelocity(VG_NED::Vector{Float64}, VW_NED::Vector{Float64} = zeros(3))
```
Computes the airspeed, flight path angle, the heading, and the vertical to
airspeed based trajectory reference frame transformation matrix.
"""
function AirVelocity(VG_NED::Vector{Float64}, VW_NED::Vector{Float64} = [0,0,0])
  VA_NED = VG_NED - VW_NED
  VA = norm(VA_NED)
  if VA < eps()
    γ_a = χ_a = 0
  else
    γ_a = -asin(VA_NED[3]/VA)
    χ_a = atan2(VA_NED[2], VA_NED[1])
  end
  return [VA, γ_a, χ_a], C_V2TA(γ_a, χ_a)
end

"""
```julia
C_V2TA(γ_a::Float64, χ_a::Float64)
```
Computes the transformation matrix from the V-frame to the airspeed based
trajectory frame.
"""
function C_V2TA(γ_a, χ_a)
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
function AirAttitude(C_B2V::Array{Float64,2}, C_V2TA::Array{Float64,2})
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