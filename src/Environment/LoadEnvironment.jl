#This file is simply a small script to load the enviroment files/types in the correct order

#import needed external libraries
import SPICE: furnsh, pxform, sxform, spkezr, spkpos

#Load Kernels function
LoadKernels(kernels) = furnsh(kernels)

#load PlanetEnviroment and CelestialBodies first
include("PlanetEnvironment.jl")
include("CelestialBodies.jl")
include("StarsAndPlanets.jl")

#Then, load the transformation Quaternions, which requires as input the current body
include("Transformations.jl")
include("Utils.jl")

#Then, load the models (they require the types defined in CelestialBodies.jl)
include("EnvironmentModels/GravityModels/CentralGravity.jl")
include("EnvironmentModels/PlanetModels/SphericalPlanet.jl")

#Load the Instances of the Star, Planets, and Moons
include("CelestialBodies/SolarSystemBarycenter.jl")
include("CelestialBodies/Sun.jl")
include("CelestialBodies/Mercury/MercuryBarycenter.jl")
include("CelestialBodies/Mercury/Mercury.jl")
include("CelestialBodies/Venus/VenusBarycenter.jl")
include("CelestialBodies/Venus/Venus.jl")
include("CelestialBodies/Earth/EarthMoonBarycenter.jl")
include("CelestialBodies/Earth/Earth.jl")
include("CelestialBodies/Earth/Moon.jl")
include("CelestialBodies/Mars/MarsBarycenter.jl")
include("CelestialBodies/Mars/Mars.jl")
include("CelestialBodies/Jupiter/JupiterBarycenter.jl")
include("CelestialBodies/Jupiter/Jupiter.jl")
include("CelestialBodies/Saturn/SaturnBarycenter.jl")
include("CelestialBodies/Saturn/Saturn.jl")
include("CelestialBodies/Uranus/UranusBarycenter.jl")
include("CelestialBodies/Uranus/Uranus.jl")
include("CelestialBodies/Neptune/NeptuneBarycenter.jl")
include("CelestialBodies/Neptune/Neptune.jl")
include("CelestialBodies/Pluto/PlutoBarycenter.jl")
include("CelestialBodies/Pluto/Pluto.jl")

#Load the planetary System type
include("PlanetarySystem.jl")

#Load GravitationalAccelerations
include("GravitationalAcceleration.jl")