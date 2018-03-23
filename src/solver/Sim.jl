include("..\\Vehicle\\Spacecraft.jl")
include("..\\utils\\GlobalDictionaries.jl")
include("..\\Environment\\Environment.jl")
include("SimulationOptions.jl")
include("Propagator.jl")
import DifferentialEquations: solve, ODEProblem 

#A function that executes the a single vehicle simulation. Defines the interface to the users
function sim(vehicle::Type{<:AbstractSpacecraft}, env::Environment, opt::SimulationOptions)

    #Get solver and simulation time  from Simulation options
    solver = ODEALG[opt.ODE_SolverType]
    SimulationTime = opt.SimulationTime
    ####################################################
    #Get EOM (ODEProblem) from the environment structure
    eom = EOM(vehicle, env)
    prob = ODEProblem(eom, vehicle.InitialState, (0, SimulationTime))

    ####################################################
    #Get callbacks from the vehicle systems  (vehiclesystems)


    ####################################################
    #Solve the resulting differential equations
    error("not yet implemented")
    return solve(prob, solver, callback = vehiclesystems, reltol=1e-8, abstol=1e-8)
    ####################################################
end
