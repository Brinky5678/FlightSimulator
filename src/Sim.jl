
#A function that executes the a single vehicle simulation. Defines the interface to the users
function sim(vehicle::Type{<:AbstractSpacecraft}, env::Environment, opt::SimulationOptions)
    error("not yet implemented")
    #Get solver and simulation time  from Simulation options


    ####################################################
    #Get EOM (ODEProblem) from the environment structure


    ####################################################
    #Get callbacks from the vehicle systems  (vehiclesystems)


    ####################################################
    #Solve the resulting differential equations
    return solve(eom, solver, vehiclesystems, reltol=1e-8, abstol=1e-8)
    ####################################################
end
