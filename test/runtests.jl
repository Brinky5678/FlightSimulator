using FlightSimulator
using Base.Test 

path = abspath(joinpath(dirname(@__FILE__),"..","resources"))

#Create download path if required. 
if !isdir(path)
    mkdir(path)
end 

#download Kernels if they do not exist
if !isfile("$path/de430.bsp")
    download("https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/de430.bsp", "$path/de430.bsp")
end 

if !isfile("$path/pck00010.tpc")
    download("https://naif.jpl.nasa.gov/pub/naif/pds/data/lro-l-spice-6-v1.0/lrosp_1000/data/pck/pck00010.tpc", "$path/pck00010.tpc")
end 

#Load Kernels
LoadKernels("$path/de430.bsp")
LoadKernels("$path/pck00010.tpc")

#Set time after J2000
ep = 0.0

#Define a standard system
ListOfBodies = [Earth, Moon]
StandardSystem = PlanetarySystem(ListOfBodies)
StandardPos = [6378.0, 0.0, 0.0]
scpos = GetInertialFramePos(StandardSystem, Earth, StandardPos, ep)

#Perform tests
@testset "Environment Tests" begin 
    @test FlightSimulator.parent(Earth) == FlightSimulator.parent(Moon)
    @test round.(Earth.Environment.GravityModel(Earth, [6378.0, 0.0, 0.0])*100000000)/100000 == [0.0, 0.0, 9.79871]
    @test PlanetarySystem(ListOfBodies) == StandardSystem
    @test StandardSystem.InertialFrame_Body == EarthMoonBarycenter
    @test round.(GetGravAccel(StandardSystem, scpos, ep)*100000000)/100000 == [-1.72622, -9.64544, -1.0e-5]
end
