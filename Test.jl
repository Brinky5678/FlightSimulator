include("src\\utils\\QuatLib.jl")
include("src\\Environment\\LoadEnvironment.jl")
LoadKernels("D:\\EphemerisData\\cg_1950_2050_v01.bsp")
LoadKernels("D:\\EphemerisData\\pck00010.tpc")

println(BodyFixed2Inertial3(Earth,0.))
println(CelestialBodyState(SSB, Earth, 0.))
println(spkezr(0,0.0,"J2000",399))
println(CelestialBodyState(Earth, Earth, 0.))