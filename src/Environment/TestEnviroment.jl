#This file contains all the tests of the Environment Types 
using Base.Test 
include("LoadEnvironment.jl")

#Define a standard system
ListOfBodies = [Sun, Earth, Luna, Mars]
StandardSystem = PlanetarySystem(ListOfBodies)

#Perform tests
@testset "Environment Tests" begin 
    @test parent(Earth) == parent(Luna)
    @test round.(Earth.Environment.GravityModel(Earth, [6378000.0, 0.0, 0.0])*100000)/100000 == [0.0, 0.0, 9.79871]
    @test PlanetarySystem(ListOfBodies) == StandardSystem
end

