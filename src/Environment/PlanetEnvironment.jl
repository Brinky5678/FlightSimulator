#= New PlanetEnvironment Structure
- For each Celestial body;
    + Ability to select a gravity model (spherical by default)
    + Ability to select a planetary model (spherical by default)
    + Ability to select a atmosphere model (none by default)
    + Ability to select a wind model (none by default)

    Note that all models are centred at the barycenter of each body. Relative positioning
    is computed in the equations of motion.
=#

abstract type AbstractPlanetEnvironment end

struct PlanetEnvironment <: AbstractPlanetEnvironment
    GravityModel::Function
    PlanetModel::Function
    AtmosphereFlag::Bool #Boolean to determine whether atmoshpere model should be looked at
    AtmosphereModel::Function
    WindFlag::Bool #Boolean to determine whether wind model should be looked at
    WindModel::Function
end
