#Defines the Guidance system type, including its discrete time behaviour

#Define ControlSystem as a subtype of the DiscreteTimeSystem
abstract type AbstractGuidanceSystem <: DiscreteTimeSystem end

########### Template function ###########################
mutable struct GuidanceSystem{T <: Number} <: AbstractGuidanceSystem
    Active::Bool
    Ts::T #sample time
    GuidanceRelation::Function
    Tprev::T #storage for previous time it was updated, hence must be a mutable type
end
GuidanceSystem() = GuidanceSystem(false, 0.0, x -> 0., 0.0)
GuidanceSystem(Ts::Number) = GuidanceSystem(false, Float64(Ts), x -> 0., 0.0)
GuidanceSystem(Ts::Number, gsfunc::Function) = GuidanceSystem(true, Float64(Ts), gsfunc, 0.0)
GuidanceSystem(Active::Bool, Ts::Number, gsfunc::Function) = GuidanceSystem(Active, Float64(Ts), gsfunc, 0.0)
#Set the callback affect condition of the ControlSystem

function CreateGuidanceCallback(gs::T) where {T <: AbstractGuidanceSystem}
    affect! = function (int, dts::Type{<:AbstractGuidanceSystem})
        for cu in user_cache(int)
            cu.GuidanceVector = [dts.GuidanceRelation(int.u)...]
        end
        dts.Tprev = int.t
    end
    return ContinuousCallback((u, t, int) -> condition(u, t, int, gs), (int) -> affect!(int, gs))
end 
 
