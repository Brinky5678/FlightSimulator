module FlightSimulator


#using DifferentialEquations

export SSB, MERCURY_BARYCENTER, VENUS_BARYCENTER, EARTH_BARYCENTER, MARS_BARYCENTER, JUPITER_BARYCENTER
export SATURN_BARYCENTER, NEPTUNE_BARYCENTER, URANUS_BARYCENTER, PLUTO_BARYCENTER
export SUN, MERCURY, VENUS, EARTH, MOON, MARS, JUPITER, SATURN, NEPTUNE, URANUS, PLUTO
export abstractCelestialBody
export PlanetarySystem, GetInertialFramePos, GetGravAccel, LoadKernels, naif_id, parent, gravity

#include global Dictionaries
#include("solver\\GlobalDictionaries.jl")

#Include utility functions
include("utils/LoadUtils.jl")

#Include base function first
include("Environment/LoadEnvironment.jl")

#simulator Options
#include("solver\\SimulationOptions.jl")

#Model Properties Type
#include("ModelOptions.jl")

#Include the Aerodynamic database files
#include("Vehicle\\AeroDataBase.jl")
#include("Vehicle\\VehicleAeroDataBase.jl")

#Add Planets
#include("Planets.jl")

#Add Spacecrafts
#include("Vehicle\\Spacecraft.jl")

#Add Nozzle
#include("Vehicle\\Nozzle.jl")

#Add Actuators
#include("Vehicle\\Actuators.jl")

#include run simulation ability
#include("RunSimulation.jl")


end #module FlightSimulator
