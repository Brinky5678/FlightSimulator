#Definitions of the different reference frames used and the relations between them.
#= Frames included by default are;
    - International celastial reference Frame (ICRF)
    - CBCI (CelestialBody Centred inertial/J2000 frame)
    - CBCF (Celestial body centred and fixed)
    - Vertical (vertical/local horizon frame)
    - Aerodynamic (Aerodynamic frame )
    - Trajectory (Trajectory Frame)
Simulations will be performed in the ICRF, because this is the pseudo-inertial
reference frame that is considered are as inertial.

+ Preferably you want structs for all frames, but how then to refer them in a
tree-like structure?  Make the frames abstract struct will do the trick!
Supertypes will then determine which transformations needs to be explicetely written!
=#


#=Make for all planets and moons
for (idx, planet) in enumerate(PLANETS)
    cbciplanet = Symbol(String(planet), "CI")
    cbcfplanet = Symbol(String(planet), "CF")
    cbvplanet = Symbol(String(planet), "Vert")
    cbaplanet = Symbol(String(planet), "Aero")
    cbtplanet = Symbol(String(planet), "Traject")
end


#Make some graph with the nodes the different frames
