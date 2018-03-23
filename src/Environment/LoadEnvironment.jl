#This file is simply a small script to load the enviroment files/types in the correct order

#load PlanetEnviroment and CelestialBodies first
include("PlanetEnvironment.jl")
include("CelestialBodies.jl")

#Then, load the models (they require the types defined in CelestialBodies.jl)
include("EnvironmentModels\\GravityModels\\CentralGravity.jl")
include("EnvironmentModels\\PlanetModels\\SphericalPlanet.jl")

#Load the Instances of the Star, Planets, and Moons
include("StarsAndPlanets.jl")

#Load the planetary System type
include("PlanetarySystem.jl")