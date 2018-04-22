#This file is simply a small script to load the enviroment files/types in the correct order

#import needed external libraries
import SPICE: furnsh, pxform, sxform, spkezr, spkpos

#Load Kernels function
LoadKernels(kernels) = furnsh(kernels)

#load PlanetEnviroment and CelestialBodies first
include("PlanetEnvironment.jl")
include("CelestialBodies.jl")
#include("StarsAndPlanets.jl")

#Then, load the transformation Quaternions, which requires as input the current body
include("Transformations.jl")
include("Utils.jl")

#Then, load the models (they require the types defined in CelestialBodies.jl)
include("EnvironmentModels/GravityModels/CentralGravity.jl")
include("EnvironmentModels/PlanetModels/SphericalPlanet.jl")



#Load the planetary System type
include("PlanetarySystem.jl")

#Load GravitationalAccelerations
include("GravitationalAcceleration.jl")