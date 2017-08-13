#Add structure/type that defined actuators and their effects

#Define AbstractActuator type
abstract type AbstractActuator end

#= Define a Realstic Thruster type which includes:
    - Specific impulse (only used when infinitely throttable, to determine fuel used)
                        (set to inf if no fuel is to be used)
    - [x,y,z] position w.r.t. centre of mass of vehicle
    - Transformation matrix between body-axis of vehicle and thruster (thrust in x-direction)
    - NozzleType;
    - TypeFlag; indicates whether or not the thruster is throttable (0 = on/off, 1 = throttable)
                (if this flag is zero, a non-zero thrust setting is interpreted as on)
    - ThrottableFlag; indicates if actuator is finely throttable (0) or has limits (1)
                     if it has limits, the nozzle type will be used to determine thrust
                     as function of mass flow and pressure. If its infinitely throttable,
                     the force generated is the control variable, else its the mass flow.
    - ConstantFlag; indicates whether or not the thruster generates a constant thrust
                    (0 = constant, 1 = variable)
                    (if the flag is zero, the specific impulse is constant
                    (if the flag is one, the altitude function will be used to compute the
                    atmospheric pressure that determines the variation in generated thrust)
    -ControlGroupFlag; indicates if used for translational (0) or rotational control (1)
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
