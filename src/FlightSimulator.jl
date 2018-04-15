module FlightSimulator


#using DifferentialEquations

export SSB, MercuryBarycenter, VenusBarycenter, EarthMoonBarycenter, MarsBarycenter, JupiterBarycenter
export SaturnBarycenter, NeptuneBarycenter, UranusBarycenter, PlutoBarycenter
export Sun, Mercury, Venus, Earth, Moon, Mars, Jupiter, Saturn, Neptune, Uranus, Pluto
export SunType, MercuryType, VenusType, EarthType, MoonType, MarsType, JupiterType, SaturnType, NeptuneType, UranusType, PlutoType
export abstractCelestialBody
export PlanetarySystem, GetInertialFramePos, GetGravAccel, LoadKernels, naif_id, parent

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
