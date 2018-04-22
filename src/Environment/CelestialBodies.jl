#Define abstract planet type that functions as a wrapper of the CelestialBody struct of AstroDynBase
abstract type abstractCelestialBody end 
abstract type abstractBarycenter <: abstractCelestialBody end 
abstract type abstractPlanet <: abstractCelestialBody end 
abstract type abstractNaturalSatellite <: abstractCelestialBody end 
abstract type abstractStar <: abstractCelestialBody end 

struct Planet <: abstractPlanet 
    Name::Type{<:abstractPlanet}
    Environment::T where {T <: AbstractPlanetEnvironment}
end 

struct NaturalSatellite <: abstractNaturalSatellite
    Name::Type{<:abstractNaturalSatellite}
    Environment::T where {T <: AbstractPlanetEnvironment}
end 

struct Star <: abstractStar
    Name::Type{<:abstractStar}
end 

#Unless otherwise defined, define initial values for each of the variables
J2(::Type{C}) where {C <: abstractCelestialBody} = 0.
J3(::Type{C}) where {C <: abstractCelestialBody} = 0.
J4(::Type{C}) where {C <: abstractCelestialBody} = 0.
frame(::Type{C}) where {C <: abstractCelestialBody} = "J2000"

#Wrap the functions
naif_id(Planet::T) where {T <: abstractCelestialBody} = naif_id(Planet.Name)
mu(Planet::T) where {T <: abstractCelestialBody} = mu(Planet.Name)
mean_radius(Planet::T) where {T <: abstractCelestialBody} = mean_radius(Planet.Name)
equatorial_radius(Planet::T) where {T <: abstractCelestialBody} = equatorial_radius(Planet.Name)
polar_radius(Planet::T) where {T <: abstractCelestialBody} = polar_radius(Planet.Name)
parent(Planet::T) where {T <: abstractCelestialBody} = parent(Planet.Name)
right_ascension(Planet::T) where {T <: abstractCelestialBody} = right_ascension(Planet.Name)
right_ascension_rate(Planet::T) where {T <: abstractCelestialBody} = right_ascension_rate(Planet.Name)
declination(Planet::T) where {T <: abstractCelestialBody} = declination(Planet.Name)
declination_rate(Planet::T) where {T <: abstractCelestialBody} = declination_rate(Planet.Name)
rotation_angle(Planet::T) where {T <: abstractCelestialBody} = rotation_angle(Planet.Name)
rotation_rate(Planet::T) where {T <: abstractCelestialBody} = rotation_rate(Planet.Name)
euler_angles(Planet::T) where {T <: abstractCelestialBody} = euler_angles(Planet.Name)
euler_derivatives(Planet::T) where {T <: abstractCelestialBody} = euler_derivatives(Planet.Name)
J2(Planet::T) where {T <: abstractCelestialBody} = j2(Planet.Name)
J3(Planet::T) where {T <: abstractCelestialBody} = j3(Planet.Name)
J4(Planet::T) where {T <: abstractCelestialBody} = j4(Planet.Name)
frame(Planet::T) where {T <: abstractCelestialBody} = frame(Planet.Name)

#Compute the flattening of a CelestialBody
flattening(Body::T) where {T <: abstractCelestialBody} = 1 - (polar_radius(Body) / equatorial_radius(Body))

#Helper state-transformation matrix function 
function BodyFixed2InertialState(Body::T, t::S) where {T <: abstractCelestialBody, S <: Real} 
    sxform(frame(Body),"J2000",Float64(t))
end 

function Inertial2BodyFixedState(Body::T, t::S) where {T <: abstractCelestialBody, S <: Real} 
    sxform("J2000",frame(Body),Float64(t))
end 

function BodyFixed2Inertial3(Body::T, t::S) where {T <: abstractCelestialBody, S <: Real} 
    pxform(frame(Body),"J2000",Float64(t))
end 

function Inertial2BodyFixed3(Body::T, t::S) where {T <: abstractCelestialBody, S <: Real} 
    pxform("J2000",frame(Body),Float64(t))
end 

function CelestialBodyState(FromBody::T, ToBody::P, t::S) where {T,P <: abstractCelestialBody, S <: Real} 
    spkezr(naif_id(FromBody), Float64(t), "J2000", naif_id(ToBody))[1]
end 

function CelestialBodyPosition(FromBody::T, ToBody::P, t::S) where {T,P <: abstractCelestialBody, S <: Real} 
    spkpos(naif_id(FromBody), Float64(t), "J2000", naif_id(ToBody))[1]
end 
