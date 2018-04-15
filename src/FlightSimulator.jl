module FlightSimulator


using DifferentialEquations

export Mercury, Venus, Earth, Luna, Mars, Jupiter, Saturn, Neptune, Uranus, Pluto

#include global Dictionaries
include("solver\\GlobalDictionaries.jl")

#Include utility functions
include("utils\\MathUtils.jl")
include("utils\\Utils.jl")

#Include base function first
include("Environment\\LoadEnvironment.jl")

#simulator Options
include("solver\\SimulationOptions.jl")

#Model Properties Type
#include("ModelOptions.jl")

#Define the environment models that are included by default
include("Environment\\EnvironmentModels\\GravityModels\\CentralGravity.jl")

include("Environment\\EnvironmentModels\\GravityModels\\J2Gravity.jl")

include("Environment\\EnvironmentModels\\GravityModels\\J23Gravity.jl")

include("Environment\\EnvironmentModels\\GravityModels\\J234Gravity.jl")

include("Environment\\EnvironmentModels\\PlanetModels\\SphericalPlanet.jl")

include("Environment\\EnvironmentModels\\PlanetModels\\EllipsoidPlanet.jl")

include("Environment\\EnvironmentModels\\AtmosphereModels\\ExpoAtmos.jl")

include("Environment\\EnvironmentModels\\AtmosphereModels\\US76Atmos.jl")

#Include the Aerodynamic database files
include("Vehicle\\AeroDataBase.jl")
include("Vehicle\\VehicleAeroDataBase.jl")

#Add Planets
#include("Planets.jl")

#Add Spacecrafts
include("Vehicle\\Spacecraft.jl")

#Add Nozzle
include("Vehicle\\Nozzle.jl")

#Add Actuators
include("Vehicle\\Actuators.jl")

#include run simulation ability
#include("RunSimulation.jl")


end #module FlightSimulator
