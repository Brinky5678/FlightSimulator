#Additional constructors for the PlanetEnvironment with different number of inputs
PlanetEnvironment() = PlanetEnvironment(CentralGravity)
PlanetEnvironment(gravfunc::Function) = PlanetEnvironment(gravfunc, SphericalAltitude)
PlanetEnvironment(gravfunc::Function, planetfunc::Function) =  PlanetEnvironment(gravfunc, planetfunc, false, x-> nothing)
function PlanetEnvironment(gravfunc::Function, planetfunc::Function, atmosphereflag::Bool, atmospherefunc::Function)
    return PlanetEnvironment(gravfunc, planetfunc, atmosphereflag, atmospherefunc, false, x->nothing)
end

#Define Constructor for Planet and Moon Types
function Planet(Name::Type{<:abstractCelestialBody})
    return Planet(Name, PlanetEnvironment())
end 

function Moon(Name::Type{<:abstractCelestialBody})
    return Moon(Name, PlanetEnvironment())
end 
