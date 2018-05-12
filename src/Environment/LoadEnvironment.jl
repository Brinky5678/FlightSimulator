#This file is simply a small script to load the enviroment files/types in the correct order

#Objects to export 
export SSB, MERCURY_BARYCENTER, VENUS_BARYCENTER, EARTH_BARYCENTER, MARS_BARYCENTER, JUPITER_BARYCENTER
export SATURN_BARYCENTER, NEPTUNE_BARYCENTER, URANUS_BARYCENTER, PLUTO_BARYCENTER
export SUN, MERCURY, VENUS, EARTH, MOON, MARS, JUPITER, SATURN, NEPTUNE, URANUS, PLUTO
export abstractCelestialBody
export PlanetarySystem, GetInertialFramePos, GetGravAccel, LoadKernels, naif_id, parent, gravity

#import needed external libraries
import SPICE: furnsh, pxform, sxform, spkezr, spkpos, bodc2n, bodfnd, bodvcd

#Define the abstract types here 
abstract type abstractCelestialBody end 
abstract type abstractBarycenter <: abstractCelestialBody end 
abstract type abstractPlanet <: abstractCelestialBody end 
abstract type abstractNaturalSatellite <: abstractCelestialBody end 
abstract type abstractStar <: abstractCelestialBody end 

#Load Kernels function
LoadKernels(kernels) = furnsh(kernels...)

#Create and download the needed kernels
path = abspath(joinpath(dirname(@__FILE__),"../..","resources"))

#Create download path if required. 
if !isdir(path)
    mkdir(path)
end 

#download Kernels if they do not exist
if !isfile("$path/cg_1950_2050_v01.bsp")
    println("Starting downloading bsp file")
    download("https://naif.jpl.nasa.gov/pub/naif/cosmographia/kernels/spice/spk/cg_1950_2050_v01.bsp", "$path/cg_1950_2050_v01.bsp")
    println("Finished downloading bsp file")
end 

if !isfile("$path/pck00010.tpc")
    println("Starting downloading pck00010.tpc file")
    download("https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/pck00010.tpc", "$path/pck00010.tpc")
    println("Finished downloading pck00010.tpc file")
end 

if !isfile("$path/naif0012.tls")
    println("Starting downloading naif0012.tls file")
    download("https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls", "$path/naif0012.tls")
    println("Finished downloading naif0012.tls file")
end

if !isfile("$path/Gravity.tpc")
    println("Starting downloading Gravity.tpc file")
    download("https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/Gravity.tpc", "$path/Gravity.tpc")
    println("Finished downloading Gravity.tpc file")
end

LoadKernels(["$path/cg_1950_2050_v01.bsp","$path/naif0012.tls","$path/pck00010.tpc","$path/Gravity.tpc"])

#Load the pre-defined models
include("EnvironmentModels/GravityModels/CentralGravity.jl")
include("EnvironmentModels/PlanetModels/SphericalPlanet.jl")

#Load the objects
include("GenerateCelestialObjects.jl")
#GM(::Type{EARTH}) = 3.986004418e5

#Load the planetary System type
include("PlanetarySystem.jl")

#Then, load the transformation Quaternions, which requires as input the current body
include("Transformations.jl")
include("Utils.jl")

#Load GravitationalAccelerations
include("GravitationalAcceleration.jl")