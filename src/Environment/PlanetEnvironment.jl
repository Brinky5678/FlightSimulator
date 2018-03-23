abstract type AbstractPlanetEnvironment end

struct PlanetEnvironment <: AbstractPlanetEnvironment
    GravityModel::Function
    PlanetModel::Function
    AtmosphereFlag::Bool #Boolean to determine whether atmoshpere model should be looked at
    AtmosphereModel::Function
    WindFlag::Bool #Boolean to determine whether wind model should be looked at
    WindModel::Function
end
