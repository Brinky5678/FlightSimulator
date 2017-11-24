#Defines the Guidance system type, including its discrete time behaviour
#include("DiscreteTimeSystem.jl")

#Define ControlSystem as a subtype of the DiscreteTimeSystem
abstract type AbstractGuidanceSystem <: DiscreteTimeSystem end

########### Template function ###########################
mutable struct GuidanceSystem{T<:Number} <: AbstractGuidanceSystem
  Active::Bool
  Ts::T #sample time
  GuidanceRelation::Function
  Tprev::T #storage for previous time it was updated, hence must be a mutable type
end
Guidance() = GuidanceSystem(false, 0.0, x -> nothing, 0.0)
GuidanceSystem(Ts::Number) = GuidanceSystem(false, Float64(Ts), x -> nothing, 0.0)
GuidanceSystem(Ts::Number, csfunc::Function) = GuidanceSystem(true, Float64(Ts), csfunc, 0.0)
GuidanceSystem(Active::Bool, Ts::Number, csfunc::Function) = GuidanceSystem(Active, Float64(Ts), csfunc, 0.0)
#Set the callback affect condition of the ControlSystem
#placeholder!
function affect!(int, dts::Type{<:AbstractGuidanceSystem})
    for cu in user_cache(int)
        cu.u = [dts.GuidanceRelation(int.u)...]
    end
  dts.Tprev = int.t
end
