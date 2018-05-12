#Function for obtaining the gravitational acceleration of at a position w.r.t. the central reference frame
function GetGravAccel(sys::PlanetarySystem, PosCartI::Vector{T}, ep::S) where {T,S <: Real}
    g = zeros(3)
    for body in sys.Bodies 
        #Obtain the position of the vehicle position w.r.t. the C.o.M. of the current celestial body (inertial Frame)
        PosCartRelI = PosCartI - CelestialBodyPosition(sys.InertialFrame_Body, body, ep)

        #Transform from Inertial frame to Co-rotating Frame of the current Celestial Body
        PosCartRelR = Inertial2BodyFixed3(body, ep)*PosCartRelI

        #Compute gravitational contribution of the current celestial body in the V-frame w.r.t. the C.o.M. of the current selected body -> Transform to inertial frame
        Rsph,lon,lat = PositionCart2Sph(PosCartRelR)
        glocalv = gravity(body, [Rsph, lon , lat])

        #Compute the rotation quaternion of the V-frame of the current celestial body to the inertial frame (J2000)
        #Because they are vectors, no translation is needed, as the inertial frame of each body is equal to the global inertial frame (in orientation)        
        qv2r = Q_V2R(lon,lat)
        gbodyr = RotateVector(qv2r, glocalv) 

        g += BodyFixed2Inertial3(body,ep)*gbodyr
    end
    return g 
end 

#Clearly a need to transform a position vector w.r.t. a body to the inertial frame. 
function GetInertialFramePos(sys::PlanetarySystem, Body::Type{<:abstractCelestialBody}, Pos::Vector{S}, ep::P) where {S,P <: Real}
    return (Pos + CelestialBodyPosition(sys.InertialFrame_Body, Body, ep))
end 