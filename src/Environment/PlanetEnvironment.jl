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

###########################################OLD ########################################
#=
########## Consider Adding a time property, based on a to-be-determined epoch

#Create the
function SetPlanetProperties(planet::Type{<:CelestialBody} = Earth,
            ModelPropIn::ModelProperties = ModelProperties())
    #Set planet model type for altitude calculations
  if ModelPropIn.PlanetModelType == "none"
    altitude(::Type{planet}, PosRsph::Vector{Float64}) = 0.0
  elseif haskey(PLANETMODELTYPES, ModelPropIn.PlanetModelType)
    planetmodel = PLANETMODELFUNC[ModelPropIn.PlanetModelType]
    altitude(::Type{planet}, PosRsph::Vector{Float64}) =
      planetmodel(planet, PosRsph)
  else
    error("Planetmodel $(ModelPropIn.PlanetModelType) does not exist")
  end
  #Set gravity model type so compute gravitational forces
  if ModelPropIn.GravityModelType == "none"
    gravity(::Type{planet}, PosRsph::Vector{Float64}) = [0., 0., 0.]
  elseif haskey(GRAVITYMODELTYPES, ModelPropIn.GravityModelType)
   gravforce = GRAVITYMODELFUNC[ModelPropIn.GravityModelType]
   gravity(::Type{planet}, PosRsph::Vector{Float64}) =
    gravforce(planet, PosRsph)
 else
   error("Gravity Model $(ModelPropIn.GravityModelType) does not exist")
  end

  if ModelPropIn.AtmosphereModelType == "none"
      density(::Type{planet}, PosRsph::Vector{Float64}) = 0.
      ss(::Type{planet}, PosRsph::Vector{Float64}) = 0.
      temperature(::Type{planet}, PosRsph::Vector{Float64}) = 0.
      pressure(::Type{planet}, PosRsph::Vector{Float64}) = 0.
  elseif haskey(ATMOSPHEREMODELTYPES, ModelPropIn.AtmosphereModelType)
      atmosphere = ATMOSPHEREMODELFUNC[ModelPropIn.AtmosphereModelType]
      density(::Type{planet}, PosRsph::Vector{Float64}) =
        atmosphere(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64})[1]
      ss(::Type{planet}, PosRsph::Vector{Float64}) =
        atmosphere(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64})[2]
      temperature(::Type{planet}, PosRsph::Vector{Float64}) =
        atmosphere(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64})[3]
      pressure(::Type{planet}, PosRsph::Vector{Float64}) =
        atmosphere(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64})[4]
  else
      error("Atmosphere Model $(ModelPropIn.AtmosphereModelType) does not exist")
  end

  if ModelPropIn.WindModelType == "none"
      wind(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64}) = [0., 0., 0.]
  elseif haskey(WINDMODELTYPES, ModelPropIn.WindModelType)
      windfunc = WINDMODELFUNC[ModelPropIn.WindModelType]
      wind(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64}) = winfunc(planet, PosRsph)
  else
      error("Wind Model $(ModelPropIn.WindModelType) does not eixst")
end
=#
