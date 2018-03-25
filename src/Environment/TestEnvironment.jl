#This file contains all the tests of the Environment Types 
using Base.Test 
include("LoadEnvironment.jl")

#Load Utils seperately for testing (normally loaded first from FlightSimulator Module)
include("..\\utils\\LoadUtils.jl")

#load DE430 SPK kernal
spk = SPK("D:\\de430.bsp")

# 2016-01-01T00:00 in Modified Julian days
mjd = datetime2modifiedjulian(DateTime(2016,1,1,0,0,0))

#Define a standard system
ListOfBodies = [Earth, Luna]
StandardSystem = PlanetarySystem(ListOfBodies)
StandardPos = [-6378.0, 0.0, 0.0]
scpos = GetInertialFramePos(StandardSystem, Earth, StandardPos, mjd)

TimeVector = Vector{Float64}()
for idx = 1:1000
    tic()
    g = GetGravAccel(StandardSystem, scpos, mjd)
    time = toq() 
    push!(TimeVector, time)
end 
println("Average Time it took to calculate the gravitational forces of the standard system: " ,  string(mean(TimeVector)*1000), " ms")

#Perform tests
@testset "Environment Tests" begin 
    @test round(mjd*10)/10 == 57388.0
    @test parent(Earth) == parent(Luna)
    @test round.(Earth.Environment.GravityModel(Earth, [6378.0, 0.0, 0.0])*100000000)/100000 == [0.0, 0.0, 9.79871]
    @test PlanetarySystem(ListOfBodies) == StandardSystem
    @test StandardSystem.InertialFrame_ID == 3
    @test round.(GetGravAccel(StandardSystem, scpos, mjd)*100000000)/100000 == [-1.71685, 9.6471, 0.0]
end
