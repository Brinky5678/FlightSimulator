#Define Simulation state that also contains the control variables using the DEDataVector
#interface from the DifferentialEquations package
using DifferentialEquations

mutable struct SimState{T<:Number} <: DEDataArray{T}
    x::Array{T,1} #State variables
    u::Array{T,1} #Control Variables
    F::Type{<:AbstractFrame} #FrameType
end #SimState

SimState(x::Array{T,1}, u::Array{T,1}) where {T<:Number} = SimState(x, u, ICRF)

# Create New ODE interface that uses x_dot = f(x,u,t), instead of x_dot = f(x,t)
#Also, make sure that integration is done in ICRF reference frame
function ODEProblem(f::Function, x0::Vector{T}, u0::Vector{T}, t0::T, tend::T) where T <: Number
    y0 = SimState(x0,u0)
    return ODEProblem(f,y0,(t0,tend))
end
