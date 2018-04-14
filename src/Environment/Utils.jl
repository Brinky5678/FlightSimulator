#Collection of utility functions

#Load Constants
const SECS = 86400.0
const MJD_J2000 = 51544.5
const JULIAN_CENTURY = 36525
const GMST_CONSTS = (24110.54841, 8640184.812866, 0.093104, 6.2e-6, 1.002737909350795)
const JD_TO_MJD = 2400000.5
const SECONDS_PER_CENTURY = SECS*JULIAN_CENTURY

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
  return (Dates.datetime2julian(dt) - JD_TO_MJD + simtime/SECS)
end 

function centuriespastJ2000(dt::DateTime, simtime::T = 0.0) where {T <: Real} 
  return (datetime2modifiedjulian(dt,simtime) - MJD_J2000)/JULIAN_CENTURY
end 

