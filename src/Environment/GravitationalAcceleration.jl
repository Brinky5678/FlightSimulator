#Function for obtaining the gravitational acceleration of at a position w.r.t. the central reference frame
function GetGravAccel(sys::PlanetarySystem, Pos::Vector{T}, mjdin::S) where {T,S <: Real}
    g = zeros(3)
    if sys.InertialFrame_ID != -1 #if sys.InertialFrame_ID == 1, then free space, so no gravitational forces
        for body in sys.Bodies 
            #Obtain the position of the vehicle position w.r.t. the C.o.M. of the current celestial body
            if sys.InertialFrame_ID != naif_id(body)
                PosCart = Pos - position(spk, sys.InertialFrame_ID, naif_id(body), mjdin + JD_TO_MJD)
            else
                PosCart = Pos
            end 
            #Compute gravitational contribution of the current celestial body in the V-frame w.r.t. the C.o.M. of the current selected body -> Transform to inertial frame
            glocalv = body.Environment.GravityModel(body, PosCart)

            #Compute the rotation quaternion of the V-frame of the current celestial body to the inertial frame (J2000)
            #Because they are vectors, no translation is needed, as the inertial frame of each body is equal to the global inertial frame (in orientation)
            GMST = Get_GMST(mjdin)
            Rsph,lon,lat = PositionCart2Sph(PosCart)
            warn("The usual I to R frame transformations as defined now only works for the Earth! Not for Anything else!")
            warn("Use the RA, DEC, and PM angles from the databases to compute a proper transformation matrix from the angles (Z-X-Z) => (RA, DEC, PM)")
            qv2i = Q_V2I(GMST,lon,lat)
            g += RotateVector(qv2i, glocalv)
        end
    end  
    return g 
end 

#Clearly a need to transform a position vector w.r.t. a body to the inertial frame. 
function GetInertialFramePos(sys::PlanetarySystem, Body::T, Pos::Vector{S}, mjdin::P) where {T <: abstractCelestialBody, S,P <: Real}
    if sys.InertialFrame_ID == -1 #Floating in free space
        return Pos 
    elseif sys.InertialFrame_ID == naif_id(Body) #Current body is inertial frame
        return Pos 
    else #otherwise
        return (Pos + position(spk, sys.InertialFrame_ID, naif_id(Body), mjdin + JD_TO_MJD))
    end 
end 