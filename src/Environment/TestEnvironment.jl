#This file contains all the tests of the Environment Types 
using Base.Test 
include("LoadEnvironment.jl")

#Load Utils seperately for testing (normally loaded first from FlightSimulator Module)
include("..\\utils\\LoadUtils.jl")

#Load Kernels
LoadKernels("D:\\EphemerisData\\cg_1950_2050_v01.bsp")
LoadKernels("D:\\EphemerisData\\pck00010.tpc")

#Set time after J2000
ep = 0.0

#Define a standard system
ListOfBodies = [Earth, Moon]
StandardSystem = PlanetarySystem(ListOfBodies)
StandardPos = [6378.0, 0.0, 0.0]
scpos = GetInertialFramePos(StandardSystem, Earth, StandardPos, ep)

TimeVector = Vector{Float64}()
for idx = 1:10000
    tic()
    g = GetGravAccel(StandardSystem, scpos, ep)
    time = toq() 
    push!(TimeVector, time)
end 
println("Average Time it took to calculate the gravitational forces of the standard system: " ,  string(mean(TimeVector)*1000), " ms")

#Perform tests
@testset "Environment Tests" begin 
    @test parent(Earth) == parent(Moon)
    @test round.(Earth.Environment.GravityModel(Earth, [6378.0, 0.0, 0.0])*100000000)/100000 == [0.0, 0.0, 9.79871]
    @test PlanetarySystem(ListOfBodies) == StandardSystem
    @test StandardSystem.InertialFrame_Body == EarthMoonBarycenter
    @test round.(GetGravAccel(StandardSystem, scpos, ep)*100000000)/100000 == [-1.72622, -9.64544, -1.0e-5]
end
