#Defines the control system type, including its discrete time behaviour
#include("DiscreteTimeSystem.jl")

#Define ControlSystem as a subtype of the DiscreteTimeSystem
mutable struct GuidanceSystem{T<:Number} <: DiscreteTimeSystem
  Ts::T #sample time
  GuidanceRelation::Function
  Tprev::T #storage for previous time it was updated, hence must be a mutable type
end
GuidanceSystem(Ts::Number) = GuidanceSystem(Float64(Ts), x -> (), 0.0)
GuidanceSystem(Ts::Number, csfunc::Function) = GuidanceSystem(Float64(Ts), csfunc, 0.0)

#Set the callback affect condition of the ControlSystem
function affect!(int,dts::GuidanceSystem)
    for cu in user_cache(int)
        cu.u = [dts.GuidanceRelation(int.u)...]
    end
  dts.Tprev = int.t
end
