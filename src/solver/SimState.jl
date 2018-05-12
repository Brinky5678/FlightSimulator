#Define Simulation state that also contains the control variables using the DEDataVector
#interface from the DifferentialEquations package

mutable struct SimState{Float64} <: DEDataVector{Float64}
    x::State #State variables
    MissionVector::Vector{Float64}
    GuidanceVector::Vector{Float64}
    ControlVector::Vector{Float64} #Control Variables
    NavigationVector::Vector{Float64}
end #SimState

SimState() = SimState(State())
SimState(x::State) = SimState(x, [0.], [0.], [0.], [0.])
SimState(x::State, mv::Vector{Float64}) = SimState(x, mv, [0.], [0.], [0.])
SimState(x::State, mv::Vector{Float64}, gv::Vector{Float64}) = SimState(x, mv, gv, [0.], [0.])
SimState(x::State, mv::Vector{Float64}, gv::Vector{Float64}, cv::Vector{Float64}) = SimState(x, mv, gv, cv, [0.])
SimState(x::Array{Float64,1}, mv::Array{Float64,1}, gv::Array{Float64,1}, cv::Array{Float64,1}, nv::Array{Float64,1}) = SimState(State(x), mv, gv, cv, nv)

# Create New ODE interface that uses x_dot = f(x,u,t), instead of x_dot = f(x,t)
function ODEProblem(f::Function, x0::State, mv::Vector{Float64}, gv::Vector{Float64}, cv::Vector{Float64}, nv::Vector{Float64}, t0::Float64, tend::Float64)
    y0 = SimState(x0, mv, gv, cv, nv)
    return ODEProblem(f,y0,(t0,tend))
end
