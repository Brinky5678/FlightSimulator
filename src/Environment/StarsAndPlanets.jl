include("CelestialBodies.jl")
#include("PlanetEnvironment.jl")
include("EnvironmentModels\\GravityModels\\CentralGravity.jl")
include("EnvironmentModels\\PlanetModels\\SphericalPlanet.jl")

#Additional constructors for the PlanetEnvironment with different number of inputs
PlanetEnvironment() = PlanetEnvironment(CentralGravity)
PlanetEnvironment(gravfunc::Function) = PlanetEnvironment(gravfunc, SphericalAltitude)
PlanetEnvironment(gravfunc::Function, planetfunc::Function) =  PlanetEnvironment(gravfunc, planetfunc, false, x-> nothing)
function PlanetEnvironment(gravfunc::Function, planetfunc::Function, atmosphereflag::Bool, atmospherefunc::Function)
    return PlanetEnvironment(gravfunc, planetfunc, atmosphereflag, atmospherefunc, false, x->nothing)
end

#Define Constructor for Planet and Moon Types
function Planet(Name::Type{<:CelestialBody})
    return Planet(Name, PlanetEnvironment())
end 

function Moon(Name::Type{<:CelestialBody})
    return Moon(Name, PlanetEnvironment())
end 

#Define Stars and Planetary Bodies with wrapper
Sun = Star(SunType)
Mercury = Planet(MercuryType)
Venus = Planet(VenusType)
Earth = Planet(EarthType)
Luna = Moon(MoonType)
Mars = Planet(MarsType)
Jupiter = Planet(JupiterType)
Saturn = Planet(SaturnType)
Uranus = Planet(UranusType)
Neptune = Planet(NeptuneType)
Pluto = Planet(PlutoType)

################################# 
#-------- Testing Only ----------
#################################
#println((parent(Earth) == parent(Luna)))
println(j2(Earth))
println(Earth.Environment.GravityModel(Earth, [6378000.0, 0.0, 0.0]))