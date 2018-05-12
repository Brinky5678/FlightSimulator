#This file loads the vehicle components in the correct order

#Export the objects 
export RigidBodyVehicle, ControlSystem, GuidanceSystem, NavigationSystem, MissionSystem, AeroDataBase, VehicleAeroDataBase
export AbstractMissionSystem, AbstractControlSystem, AbstractGuidanceSystem, AbstractNavigationSystem, AbstractSpacecraft, EOM

#Import the things needed from DifferentialEquations module 
import DifferentialEquations: ContinuousCallback

#Include the DiscreteTimeSystem option 
include("DiscreteTimeSystem.jl")

#Load the Subsystems. 
include("AeroDataBase.jl")
include("VehicleAeroDataBase.jl")
include("MissionSystem.jl")
include("GuidanceSystem.jl")
include("ControlSystem.jl")
include("NavigationSystem.jl")

#include Vehicle Type
include("Spacecraft.jl")

