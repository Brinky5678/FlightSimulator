module FlightSimulator


#using JPLEphemeris
import JPLEphemeris: SPK, print_segments, Dates, position, velocity, state
import AstronomicalTime: TAI, TT, UTC, UT1, TCG, TCB, TDB, Epoch

export Mercury, Venus, Earth, Moon, Mars, Jupiter, Saturn, Neptune, Uranus, Pluto

#Include utility functions
include("MathUtils.jl")
include("Utils.jl")

#Include base function first
include("FlightSimBase.jl")

#simulator Options
include("SimulationOptions.jl")

#Model Properties Type
include("ModelOptions.jl")

#Define the environment models that are included by default
include("Models\\GravityModels\\CentralGravity.jl")

include("Models\\GravityModels\\J2Gravity.jl")

include("Models\\GravityModels\\J23Gravity.jl")

include("Models\\GravityModels\\J234Gravity.jl")

include("Models\\PlanetModels\\SphericalPlanet.jl")

include("Models\\PlanetModels\\EllipsoidPlanet.jl")

include("Models\\AtmosphereModels\\ExpoAtmos.jl")

include("Models\\AtmosphereModels\\US76Atmos.jl")

#Include the Aerodynamic database files
include("AeroDataBase.jl")
include("VehicleAeroDataBase.jl")

#Add Planets
include("Planets.jl")

#Add Spacecrafts
include("Spacecraft.jl")

#Add Nozzle
include("Nozzle.jl")

#Add Actuators
include("Actuators.jl")

#include run simulation ability
include("RunSimulation.jl")


end #module FlightSimulator
