include("FlightSimBase.jl")
include("ModelOptions.jl")

#= new functions for the different planets describing;
    - Atmosphere models
    - More Gravity models
    - Altitude models (geoid)

These functions extend the CelestialBody type and its children as found in AstroDynBase.jl
=#

#Compute the flattening of a CelestialBody
flattening(Body::Type{<:CelestialBody}) = 1 - (polar_radius(Body)/equatorial_radius(Body))
#Additional Parameters of the Bodies
j3(::Type{Earth}) = -2.532e-6
j4(::Type{Earth}) = -1.61e-6
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
