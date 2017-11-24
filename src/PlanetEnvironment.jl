#= New PlanetEnvironment Structure
- For each Celestial body;
    + Ability to select whether to include in the model - Done
    + Ability to select a gravity model
    + Ability to select a planetary model (or none)
    + Ability to select a atmosphere model (or none)
    + Ability to select a wind model (or none)

    Note that all models are centred at the barycenter of each body. Relative positioning
    is computed in the equations of motion.
=#

abstract type AbstractPlanetEnvironment end

struct PlanetEnvironment <: AbstractPlanetEnvironment
    Included::Bool
    GravityModel::Function
    PlanetFlag::Bool
    PlanetModel::Function
    AtmosphereFlag::Bool
    AtmosphereModel::Function
    WindFlag::Bool
    WindModel::Function
end
#Additional constructors with different number of inputs
PlanetEnvironment(incl::Bool) = PlanetEnvironment(incl, x-> nothing)
PlanetEnvironment(incl::Bool, gravfunc::Function) = PlanetEnvironment(incl, gravfunc,
                                                        false, x-> nothing)
PlanetEnvironment(incl::Bool, gravfunc::Function, planetflag::Bool, planetfunc::Function) =
    PlanetEnvironment(incl, gravfunc, planetflag, planetfunc, false, x-> nothing)
 function PlanetEnvironment(incl::Bool, gravfunc::Function, planetflag::Bool, planetfunc::Function,
    atmosphereflag::Bool, atmospherefunc::Function)
    return PlanetEnvironment(incl, gravfunc, planetflag, planetfunc,
                                atmosphereflag, atmospherefunc, false, x->nothing)
end
#



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
