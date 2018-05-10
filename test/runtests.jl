using FlightSimulator
using Base.Test 

#Set time after J2000
ep = 0.0

#Define a standard system
ListOfBodies = [EARTH, MOON]
StandardSystem = PlanetarySystem(ListOfBodies)
StandardPos = [6378.0, 0.0, 0.0]
scpos = GetInertialFramePos(StandardSystem, EARTH, StandardPos, ep)

#Another StandardSystem
ListOfBodies2 = [SUN,EARTH,MOON] 
StandardSystem2 = PlanetarySystem(ListOfBodies2)
scpos2 = GetInertialFramePos(StandardSystem2, EARTH, StandardPos, ep)

#Perform tests
@testset "Environment Tests" begin 
    @test FlightSimulator.parent(EARTH) == FlightSimulator.parent(MOON)
    @test round.(gravity(EARTH, [6378.0, 0.0, 0.0]) * 100000000) / 100000 == [0.0, 0.0, 9.80015]
    @test PlanetarySystem(ListOfBodies) == StandardSystem
    @test PlanetarySystem(ListOfBodies2) == StandardSystem2
    @test StandardSystem.InertialFrame_Body == EARTH_BARYCENTER
    @test StandardSystem2.InertialFrame_Body == SSB 
    @test round.(GetGravAccel(StandardSystem, scpos, ep) * 100000000) / 100000 == [-1.72648, -9.64686, -1.0e-5]
    @test round.(GetGravAccel(StandardSystem2, scpos2, ep) * 100000000) / 100000 == [-1.76092, -9.47435, 0.06882]
end
