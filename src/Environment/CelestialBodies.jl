#Define abstract planet type that functions as a wrapper of the CelestialBody struct of AstroDynBase
abstract type abstractCelestialBody end 
abstract type abstractPlanet <: abstractCelestialBody end 
abstract type abstractMoon <: abstractCelestialBody end 
abstract type abstractStar <: abstractCelestialBody end 

struct Planet <: abstractPlanet 
    Name::Type{<:CelestialBody}
    Environment::T where {T <: AbstractPlanetEnvironment}
end 

struct Moon <: abstractMoon
    Name::Type{<:CelestialBody}
    Environment::T where {T <: AbstractPlanetEnvironment}
end 

struct Star <: abstractStar
    Name::Type{<:CelestialBody}
end 

#Define PlanetTypes
SunType = AstroDynBase.Sun 
MercuryType = PLANETS[1] 
VenusType = (PLANETS[2])
EarthType = (PLANETS[3])
LunaType = (SATELLITES[1])
MarsType = (PLANETS[4])
JupiterType = (PLANETS[5])
SaturnType = (PLANETS[6])
UranusType = (PLANETS[7])
NeptuneType = (PLANETS[8])
PlutoType = (MINORBODIES[1])

#Add naif_id of pluto, not standard included in AstroDynBase
struct PlutoBarycenter <: Barycenter end
naif_id(::Type{PlutoBarycenter}) = 9
parent(::Type{PlutoBarycenter}) = SSB

#Compute the flattening of a CelestialBody
flattening(Body::T) where {T <: abstractCelestialBody} = 1 - (polar_radius(Body)/equatorial_radius(Body))

#Additional Parameters of the Bodies
j3(::Type{EarthType}) = -2.532e-6
j4(::Type{EarthType}) = -1.61e-6

#Wrap the functions
naif_id(Planet::T) where {T <: abstractCelestialBody} = naif_id(Planet.Name)
μ(Planet::T) where {T <: abstractCelestialBody} = μ(Planet.Name)
mu(Planet::T) where {T <: abstractCelestialBody} = mu(Planet.Name)
j2(Planet::T) where {T <: abstractCelestialBody} = j2(Planet.Name)
mean_radius(Planet::T) where {T <: abstractCelestialBody} = mean_radius(Planet.Name)
equatorial_radius(Planet::T) where {T <: abstractCelestialBody} = equatorial_radius(Planet.Name)
polar_radius(Planet::T) where {T <: abstractCelestialBody} = polar_radius(Planet.Name)
maximum_elevation(Planet::T) where {T <: abstractCelestialBody} = maximum_elevation(Planet.Name)
maximum_depression(Planet::T) where {T <: abstractCelestialBody} = maximum_depression(Planet.Name)
deviation(Planet::T) where {T <: abstractCelestialBody} = deviation(Planet.Name)
parent(Planet::T) where {T <: abstractCelestialBody} = parent(Planet.Name)
show(Planet::T) where {T <: abstractCelestialBody} = show(Planet.Name)
right_ascension(Planet::T) where {T <: abstractCelestialBody} = right_ascension(Planet.Name)
right_ascension_rate(Planet::T) where {T <: abstractCelestialBody} = right_ascension_rate(Planet.Name)
declination(Planet::T) where {T <: abstractCelestialBody} = declination(Planet.Name)
declination_rate(Planet::T) where {T <: abstractCelestialBody} = declination_rate(Planet.Name)
rotation_angle(Planet::T) where {T <: abstractCelestialBody} = rotation_angle(Planet.Name)
rotation_rate(Planet::T) where {T <: abstractCelestialBody} = rotation_rate(Planet.Name)
euler_angles(Planet::T) where {T <: abstractCelestialBody} = euler_angles(Planet.Name)
euler_derivatives(Planet::T) where {T <: abstractCelestialBody} = euler_derivatives(Planet.Name)
j3(Planet::T) where {T <: abstractCelestialBody} = j3(Planet.Name)
j4(Planet::T) where {T <: abstractCelestialBody} = j4(Planet.Name)