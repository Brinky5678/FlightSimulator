#Definitions of the different reference frames used and the relations between them.
#= Frames included by default are;
    - International celastial reference Frame (ICRF)
    - CBCI (CelestialBody Centred inertial/J2000 frame)
    - CBCF (Celestial body centred and fixed)
    - Vertical (vertical/local horizon frame)
    - Trajectory (Trajectory Frame)
    - Aerodynamic (Aerodynamic frame )
    - Body (Body frame)
Simulations will be performed in the ICRF, because this is the pseudo-inertial
reference frame that is considered are as inertial.

+ Preferably you want structs for all frames, but how then to refer them in a
tree-like structure?  Make the frames abstract struct will do the trick!
Supertypes will then determine which transformations needs to be explicetely written!
=#

#Define abstract transformable type


abstract type AbstractFrame end

function NewFrame(name::String)
    FrameName = Symbol(name)
    @eval begin
        struct $FrameName <: AbstractFrame end
    end
end

#Global frames that do not require the position of the vehicle
NewFrame("ICRF")
NewFrame("ECI")
NewFrame("ECEF")

#Frames that requre the state of the vehicle
NewFrame("Vertical")
NewFrame("Trajectory")
#NewFrame("Body") -> should be the vehicle type

#create transformation functions for pre-defined frames
