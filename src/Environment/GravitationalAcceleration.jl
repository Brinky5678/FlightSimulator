#Function for obtaining the gravitational acceleration of at a position w.r.t. the central reference frame
function GetGravAccel(sys::PlanetarySystem, Pos::Vector{T}, ep::S) where {T,S <: Real}
    g = zeros(3)
    for body in sys.Bodies 
        #Obtain the position of the vehicle position w.r.t. the C.o.M. of the current celestial body
        PosCart = Pos - CelestialBodyPosition(sys.InertialFrame_Body, body, ep)

        #Compute gravitational contribution of the current celestial body in the V-frame w.r.t. the C.o.M. of the current selected body -> Transform to inertial frame
        glocalv = body.Environment.GravityModel(body, PosCart)

        #Compute the rotation quaternion of the V-frame of the current celestial body to the inertial frame (J2000)
        #Because they are vectors, no translation is needed, as the inertial frame of each body is equal to the global inertial frame (in orientation)
        Rsph,lon,lat = PositionCart2Sph(PosCart)
        qv2r = Q_V2R(lon,lat)
        gbodyr = RotateVector(qv2r, glocalv) 
        g += BodyFixed2Inertial3(body,ep)*gbodyr
    end
    return g 
end 

#Clearly a need to transform a position vector w.r.t. a body to the inertial frame. 
function GetInertialFramePos(sys::PlanetarySystem, Body::T, Pos::Vector{S}, ep::P) where {T <: abstractCelestialBody, S,P <: Real}
    return (Pos + CelestialBodyPosition(sys.InertialFrame_Body, Body, ep))
end 