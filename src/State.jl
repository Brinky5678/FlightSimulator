#Define Simulation state that also contains the control variables using the DEDataVector
#interface from the DifferentialEquations package
using DifferentialEquations

mutable struct SimState{Float64} <: DEDataVector{Float64}
    x::Vector{Float64} #State variables
    u::Vector{Float64} #Control Variables
    F::Type{<:AbstractFrame} #FrameType
end #SimState

SimState(x::Vector{Float64}, u::Vector{Float64}) = SimState(x, u, ICRF)

# Create New ODE interface that uses x_dot = f(x,u,t), instead of x_dot = f(x,t)
#Also, make sure that integration is done in ICRF reference frame
function ODEProblem(f::Function, x0::Vector{Float64}, u0::Vector{Float64}, t0::Float64, tend::Float64)
    y0 = SimState(x0,u0)
    return ODEProblem(f,y0,(t0,tend))
end
