#Function for obtaining the gravitational acceleration of at a position w.r.t. the central reference frame
function GetGravAccel(sys::PlanetarySystem, Pos::Vector{Float64}, mjdin::Float64)
    g = zeros(3)
    if sys.InertialFrame_ID != -1
        for body in sys.Bodies 
            if sys.InertialFrame_ID != naif_id(body)
                BodyPos = position(spk, sys.InertialFrame_ID, naif_id(body), mjdin + JD_TO_MJD)
            else
                BodyPos = [0.0, 0.0, 0.0]
            end 
            g += body.Environment.GravityModel(body, Pos - BodyPos)
        end
    end  
    return g 
end 

#Clearly a need to transform a position vector w.r.t. a body to the inertial frame. 
function GetInertialFramePos(sys::PlanetarySystem, Body::T, Pos::Vector{Float64}, mjdin::Float64) where {T <: abstractCelestialBody}
    if sys.InertialFrame_ID == -1 #Floating in free space
        return Pos 
    elseif sys.InertialFrame_ID == naif_id(Body) #Current body is inertial frame
        return Pos 
    else #otherwise
        return (Pos + position(spk, sys.InertialFrame_ID, naif_id(Body), mjdin + JD_TO_MJD))
    end 
end 