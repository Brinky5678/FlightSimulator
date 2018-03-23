#This file contains all the tests of the Environment Types 
using Base.Test 
include("LoadEnvironment.jl")

#load DE430 SPK kernal
spk = SPK("D:\\de430.bsp")

# 2016-01-01T00:00 in Julian days
jd = Dates.datetime2julian(DateTime(2016,1,1,0,0,0))


#Define a standard system
ListOfBodies = [Earth, Luna]
StandardSystem = PlanetarySystem(ListOfBodies)
StandardPos = [-6378.0, 0.0, 0.0]
scpos = GetInertialFramePos(StandardSystem, Earth, StandardPos, jd)

TimeVector = Vector{Float64}()
for idx = 1:1000
    tic()
    g = GetGravAccel(StandardSystem, scpos, jd)
    time = toq() 
    push!(TimeVector, time)
end 
println(mean(TimeVector))

#Perform tests
@testset "Environment Tests" begin 
    @test parent(Earth) == parent(Luna)
    @test round.(Earth.Environment.GravityModel(Earth, [6378.0, 0.0, 0.0])*100000000)/100000 == [0.0, 0.0, 9.79871]
    @test PlanetarySystem(ListOfBodies) == StandardSystem
    @test StandardSystem.InertialFrame_ID == 3
    @test round.(GetGravAccel(StandardSystem, scpos, jd)*100000000)/100000 == [0.0, 0.0, 9.79874]
end
