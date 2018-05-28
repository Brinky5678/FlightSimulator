#A function that executes the a single vehicle simulation. Defines the interface to the users
function sim(vehicle::S, env::PlanetarySystem, ep::T, opt::SimulationOptions) where {T <: Real, S <: AbstractSpacecraft}

    #Get solver and simulation time  from Simulation options
    solver = ODEALG[opt.ODE_SolverType]
    SimulationTime = opt.SimulationTime
    ####################################################
    #Get EOM (ODEProblem) from the environment structure
    eom = EOM(vehicle, env, ep, opt)
    prob = ODEProblem(eom, vehicle.InitialState, (0, SimulationTime))

    ####################################################
    #Get callbacks from the vehicle systems  (vehiclesystems)
    #vehiclesystems = 0

    ####################################################
    #Solve the resulting differential equations
    #error("not yet implemented")
    return solve(prob, solver,dtmax = 1)#, callback = vehiclesystems, reltol=1e-8, abstol=1e-8)
    ####################################################
end
