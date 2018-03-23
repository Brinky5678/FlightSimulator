#= Create ODEProblem from the selected Model and Simulation options, and also the selected
    vehicle configurations
=#
import JPLEphemeris: SPK, Dates, position, velocity, state
include("..\\Vehicle\\Spacecraft.jl")
include("..\\Environment\\Environment.jl")
include("State.jl")


#Create EOM from the vehicle configurations
function EOM(vehicle::Type{<:AbstractSpacecraft}, env::Environment)

    # Gravity (Environment-based)
    #


    # VehicleShapeAerodynamics (Vehicle properties, combined with environmental properties)



    # VehicleActuators (Vehicle properties, combined with environmental properties)

    eomfunc = function (y::SimState, t::Float64)

    end #eomfunc
    return eomfunc
end #EOM
