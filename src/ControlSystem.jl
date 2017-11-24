#Defines the control system type, including its discrete time behaviour
#include("DiscreteTimeSystem.jl")
#= ControlFunction should input the "measured state" of the vehicle obtained from the
    Navigation system, the attitude/rate commands from the guidance system, and time.
=#

#Define ControlSystem as a subtype of the DiscreteTimeSystem
abstract type AbstractControlSystem <: DiscreteTimeSystem end

########### Template function ###########################
mutable struct ControlSystem{T <: Number} <: AbstractControlSystem
    Active::Bool #Activation Boolean
    Ts::T #Sample Time
    ControlRelation::Function #Encodes
    Tprev::T # Storage for previous activation values
end
ControlSystem() = ControlSystem(false, 0.0, x -> nothing, 0.0)
ControlSystem(Ts::Number) = ControlSystem(false, Float64(Ts), x -> nothing, 0.0)
ControlSystem(Ts::Number, csfunc::Function) = ControlSystem(true, Float64(Ts), csfunc, 0.0)
ControlSystem(Active::Bool, Ts::Number, csfunc::Function) = ControlSystem(Active, Float64(Ts), csfunc, 0.0)

#Set the callback affect condition of the ControlSystem
#placeholder!
function affect!(int,dts::Type{<:AbstractControlSystem})
    for cu in user_cache(int)
        cu.u = [dts.ControlRelation(int.u)...]
    end
  dts.Tprev = int.t
end

#=cb = ContinuousCallback((t, u, int) -> condition(det,t,u,int),
                          (int) -> affect!(int,det))
=#
