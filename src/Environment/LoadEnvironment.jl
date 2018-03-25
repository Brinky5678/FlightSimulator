#This file is simply a small script to load the enviroment files/types in the correct order

#import needed external libraries
import JPLEphemeris: SPK, position
import AstroDynBase: PLANETS, MINORBODIES, SATELLITES, CelestialBody, Barycenter, SSB
import AstroDynBase: naif_id, μ, mu, j2, mean_radius, equatorial_radius, polar_radius,
    maximum_elevation, maximum_depression, deviation, parent, show,
    right_ascension, right_ascension_rate, declination, declination_rate,
    rotation_angle, rotation_rate, euler_angles, euler_derivatives

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

#Load GravitationalAccelerations
include("GravitationalAcceleration.jl")