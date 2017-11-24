#= Create ODEProblem from the selected Model and Simulation options, and also the selected
    vehicle configurations
=#
import JPLEphemeris: SPK, Dates, position, velocity, state

#Create EOM from the vehicle configurations
function EOM(vehicle::Type{<:AbstractSpacecraft}, env::Environment)

    #Create EOM function to be used in the solver
    #=Contribution are:
        - Gravity (Environment-based)
        - VehicleShape (Vehicle properties, combined with environmental properties)
        - VehicleActuators (Vehicle properties, combined with environmental properties)
    =#
    eomfunc = function (y::SimState, t::Float64)

    end #eomfunc
    return eomfunc
end #EOM
