#= Create ODEProblem from the selected Model and Simulation options, and also the selected
    vehicle configurations
=#

#Create EOM from the vehicle configurations
function EOM(vehicle::Type{<:AbstractSpacecraft}, simoptions::SimulationProperties)

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

#Create Function that solves the EOM and performs the simulation
function Sim(vehicle::Type{<:AbstractSpacecraft}, simoptions::SimulationProperties)
    f = EOM(vehicle, simoptions) #Get EOM function

    sol = solve(prob, alg, reltol=1e-8, abstol=1e-8)
end #sim
