#= Create ODEProblem from the selected Model and Simulation options, and also the selected
    vehicle configurations
=#

#Create EOM from the vehicle configurations
function EOM(vehicle::S, env::PlanetarySystem, ep::T, simopts::SimulationOptions) where {T <: Real, S <: AbstractSpacecraft}
    #Create the actual eom 
    ##TranslationalParts of EOM 
    transeomfunc = function (dy, y, p , t)
        AccelContr = zeros(3) 

        # Gravity (Environment-based)
        AccelContr += GetGravAccel(env, y[4:6], ep + t)

        # VehicleShapeAerodynamics (Vehicle properties, combined with environmental properties)

        # VehicleActuators (Vehicle properties, combined with environmental properties)

        #Relate contributions to derivative of state vector
        dy[1:3] = AccelContr 
        dy[4:6] = y[1:3]
    end 

    ## RotationalParts of EOM
    roteomfunc = function (dy, y, p, t)
        MomentContr = zeros(3)

        # VehicleShapeAerodynamics (Vehicle properties, combined with environmental properties)

        # VehicleActuators (Vehicle properties, combined with environmental properties)

        #Relate contributions to derivative of state vector
        dy[7:9] = vehicle.InvInertiaTensor * (MomentContr - cross(y[7:9], vehicle.InertiaTensor * y[7:9]))

        ##Compute quaternion correction to maintain unit length
        corr = 0.5 .* 1.5 * (1 - norm(dy[10:13])) .* y[10:13]
        XI = [-dy[11:13]'; dy[10] * eye(3) + [0 -dy[13] dy[12]; dy[13] 0 -dy[11]; -dy[12] dy[11] 0]]
        dy[10:13] = 0.5 * XI * y[7:9] + corr
    end 

    #Select the appropriate eom function parts based on the simulation settings
    if (simopts.DofSimType == "trans" || simopts.DofSimType == "5dof")
        eomfunc = (dy, y, p, t) -> transeomfunc(dy, y, p ,t)
    elseif (simopts.DofSimType == "rot")
        eomfunc = (dy, y, p, t) -> roteomfunc(dy, y, p ,t)
    elseif (simopts.DofSimType == "transrot")
        eomfunc = function (dy, y, p, t)
            transeomfunc(dy, y, p, t)
            roteomfunc(dy, y, p ,t)
        end #eomfunc
    end

    return eomfunc
end #EOM
