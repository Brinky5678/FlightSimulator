#This file ensures that the solver parts are loaded in the correct order 

#Export the objects 
export sim, SimState, SimulationOptions, ODEALG, ODETYPES, DOFSIMTYPES, NewODEType

#Import what is needed from DifferentialEquations module 
import DifferentialEquations: solve, ODEProblem, BS3, Tsit5, Vern7, Rodas4, DEDataVector

#Load Dictionaries 
include("GlobalDictionaries.jl")

#Load Simulation Options 
include("SimulationOptions.jl")

#Load Simulation State 
include("SimState.jl")

#Load Propagator and Simulation Function 
include("Propagator.jl")
include("Sim.jl")

