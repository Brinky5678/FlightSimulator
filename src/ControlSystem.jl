#Defines the control system type, including its discrete time behaviour
#include("DiscreteTimeSystem.jl")

#Define ControlSystem as a subtype of the DiscreteTimeSystem
mutable struct ControlSystem{T<:Number} <: DiscreteTimeSystem
  Ts::T #sample time
  ControlRelation::Function
  Tprev::T #storage for previous time it was updated, hence must be a mutable type
end
ControlSystem(Ts::Number) = ControlSystem(Float64(Ts), x -> (), 0.0)
ControlSystem(Ts::Number, csfunc::Function) = ControlSystem(Float64(Ts), csfunc, 0.0)

#Set the callback affect condition of the ControlSystem
function affect!(int,dts::ControlSystem)
    for cu in user_cache(int)
        cu.u = [dts.ControlRelation(int.u)...]
    end
  dts.Tprev = int.t
end

#=cb = ContinuousCallback((t, u, int) -> condition(det,t,u,int),
                          (int) -> affect!(int,det))
=#
