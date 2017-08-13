#Add structure/type that defined actuators and their effects

#Define AbstractActuator type
abstract type AbstractActuator end

#= Define a Realstic Thruster type which includes:
    - Exhaust Velocity
    - Exhaust Area
    - Exhaust Pressure
    - Maximum Fuel rate
    - [x,y,z] position w.r.t. centre of mass of vehicle
    - Transformation matrix betwen body-axis of vehicle and thruster (thrust in x-direction)
    - TypeFlag; indicates whether or not the thruster is throttable (0 = on/off, 1 = throttable)
                (if this flag is zero, a non-zero thrust setting is interpreted as on)
    - ConstantFlag; indicates whether or not the thruster generates a constant thrust
                    (in this case, the exhaust velocity becomes the effective velocity)
    - Force generated; Computed
    - Moment generated; Computed
=#
struct RealisticThruster <: AbstractActuator

end #RealisticThruster

#allow for simplistic thruster models
struct SimpleThruster <: AbstractActuator
    ForceMoment::Vector{Float64} #Vector in body-axis frame
    TypeFlag::Bool #0 means that it generates a force, 1 means it generates a moment
end #SimpleThruster

#Define an AerodynamicEffector type
struct AerodynamicEffector <: AbstractActuator


end #AerodynamicEffector
