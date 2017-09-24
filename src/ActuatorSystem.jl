#=  Defines the actuatorSystem Type that converts control signals from the
    ControlSystem type to commands for the individual actuators
=#

mutable struct ActuatorSystem{T} <: DiscreteTimeSystem
    Ts::T #Sample Time 
    Tprev::T #previous evaluation time
end
