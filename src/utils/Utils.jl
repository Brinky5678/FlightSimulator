#Collection of utility functions
"""
```julia
  qdyn, M = Get_Dynamic_Pressure(ρ::T, V_VA::S, ss::P) where {T,S,P <: Real}
```
Computes the dynamic pressure and local Mach Number from the air density,
the airspeed (in the V-frame), and the speed of sound.
"""
function Get_Dynamic_Pressure(ρ::T, V_VA::S, ss::P) where {T,S,P <: Real}
  return 0.5*ρ*V_VA^2, V_VA/ss
end

"""
```julia
Get_GMST(MJD::T) where {T <: Real}
```
This function computes the Greenwich Mean Sidereal Time and outputs it as an
angle (0..2pi).
"""
function Get_GMST(MJD::T) where {T <: Real}
  MJD0 = floor(MJD)
  UT1 = SECS*(MJD - MJD0)
  T0 = (MJD0 - MJD_J2000) / JULIAN_CENTURY
  Tval = (MJD - MJD_J2000) / JULIAN_CENTURY  
  temp = (GMST_CONSTS[1] + GMST_CONSTS[2]*T0 + GMST_CONSTS[3]*Tval^2 - GMST_CONSTS[4]*Tval^3 + GMST_CONSTS[5]*UT1)/SECS
  return 2pi*(temp - floor(temp))
end

"""
```julia
Get_GMST(dt::DateTime, simtime::T = 0.0) where {T <: Real}
```
This function computes the Greenwich Mean Sidereal Time and outputs it as an
angle (0..2pi).
"""
function Get_GMST(dt::DateTime, simtime::T = 0.0) where {T <: Real}
  return Get_GMST(datetime2modifiedjulian(dt, simtime))
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
    atan2(PosCart[3], norm(PosCart))]
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

