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

#Create the
function SetPlanetProperties(ModelPropIn::ModelProperties, planet::Type{<:CelestialBody})

  if ModelPropIn.PlanetModelType == "none"
    altitude(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64}) = 0.0
  elseif haskey(PLANETMODELTYPES, ModelPropIn.PlanetModelType)
    planetmodel = PLANETMODELFUNC[ModelPropIn.PlanetModelType]
    altitude(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64}) =
      planetmodel(planet, PosRsph)
  else
    error("Planetmodel $(ModelPropIn.PlanetModelType) does not exist")
  end

  if ModelPropIn.GravityModelType == "none"
    gravity(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64}) = [0., 0., 0.]
  elseif haskey(GRAVITYMODELTYPES, ModelPropIn.GravityModelType)
   gravforce = GRAVITYMODELFUNC[ModelPropIn.GravityModelType]
   gravity(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64}) =
    gravforce(planet, PosRsph)
 else
   error("Gravity Model $(ModelPropIn.GravityModelType) does not exist")
  end

  function density(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64})
  end

  function ss(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64})
  end

  function temperature(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64})
  end


  function pressure(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64})
  end

  function wind(planet::Type{<:CelestialBody}, PosRsph::Vector{Float64})
  end
end



#=#Select Atmosphere Model Function
if ModelPropIn.AtmosphereModelType == "none"
 atmospherefunc = zerofunc(4)
 atmosphereprms = Vector{Float64}(0)

elseif haskey(ATMOSPHEREMODELTYPES, ModelPropIn.AtmosphereModelType)
 atmospherefunc = ATMOSPHEREMODELFUNC[ModelPropIn.AtmosphereModelType]
 atmosphereprms = ATMOSPHEREMODELPRMS[ModelPropIn.AtmosphereModelType]

else
 error("Atmosphere model type is not defined")
end

windfunc = zerofunc(3)
windprms = Vector{Float64}(0)
=#
