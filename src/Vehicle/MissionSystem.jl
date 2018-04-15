#Defines the mission system that contains the reference trajectory or other mission related
#properties.

#Define Abstract Mission System for customisability
abstract type AbstractMissionSystem end

########### Template function ###########################
mutable struct MissionSystem{T <: Number} <: AbstractMissionSystem
    Active::Bool
    Ts::T
    MissionFunction::Function
    Tprev::T
end
MissionSystem() = MissionSystem(false, 0.0, x -> nothing, 0.0)
MissionSystem(Ts::Number) = MissionSystem(false, Float64(Ts), x->nothing, 0.0)
MissionSystem(Ts::Number, missfunc::Function) = MissionSystem(true, Float64(Ts), missfunc, 0.0)
MissionSystem(Active::Bool, Ts::Number, missfunc::Function) = MissionSystem(Active, Float64(Ts), missfunc, 0.0)

#Set the callback affect condition of the ControlSystem
#placeholder!
function affect!(int,dts::Type{<:AbstractMissionSystem})
    for cu in user_cache(int)
        cu.u = [dts.MissionFunction(int.u)...]
    end
  dts.Tprev = int.t
end
