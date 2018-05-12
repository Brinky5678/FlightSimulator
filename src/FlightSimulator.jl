module FlightSimulator

#Create AbstractSpacecraft type
abstract type AbstractSpacecraft end

#Include utility functions
include("utils/LoadUtils.jl")

#Include Environment parts
include("Environment/LoadEnvironment.jl")

#include solver parts 
include("solver/LoadSolver.jl")

#include Vehicle parts 
include("Vehicle/LoadVehicle.jl")

end #module FlightSimulator
