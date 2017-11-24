#Defines the Navigation system type, including its discrete time behaviour
#include("DiscreteTimeSystem.jl")
#= NavigationFunction should output the "measured state" of the vehicle, based on the
ODE state (simulated measured state) through some filter.
=#

#Define ControlSystem as a subtype of the DiscreteTimeSystem
abstract type AbstractNavigationSystem <: DiscreteTimeSystem

########### Template function ###########################
mutable struct NavigationSystem{T<:Number} <: AbstractNavigationSystem
  Active::Bool
  Ts::T #sample time
  NavigationRelation::Function
  Tprev::T #storage for previous time it was updated, hence must be a mutable type
end
NavigationSystem() = NavigationSystem(false, 0.0 , x-> nothing, 0.0)
NavigationSystem(Ts::Number) = NavigationSystem(false, Float64(Ts), x -> (), 0.0)
NavigationSystem(Ts::Number, csfunc::Function) = NavigationSystem(true, Float64(Ts), csfunc, 0.0)
NavigationSystem(Active::Bool, Ts::Number, csfunc::Function) = NavigationSystem(Active, Float64(Ts), csfunc, 0.0)

#Set the callback affect condition of the ControlSystem
#placeholder!
function affect!(int,dts::AbstractNavigationSystem)
    for cu in user_cache(int)
        cu.u = [dts.NavigationRelation(int.u)...]
    end
  dts.Tprev = int.t
end
