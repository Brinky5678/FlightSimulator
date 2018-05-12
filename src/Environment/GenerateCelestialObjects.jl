#Assume that the right kernels have been loaded that contain the relevant parameters. 
#also assume that atleast the planets (and pluto) and their respective bodies are included in the tpc kernels
#Define abstract planet type that functions as a wrapper of the CelestialBody struct of AstroDynBase

#Unless otherwise defined, define initial values for each of the variables
J2(::Type{<:abstractCelestialBody}) = 0.
J3(::Type{<:abstractCelestialBody}) = 0.
J4(::Type{<:abstractCelestialBody}) = 0.
frame(::Type{<:abstractCelestialBody}) = "J2000"

#The barycenters of the solar system and planets systems (all are included)
struct SSB <: abstractBarycenter end
naif_id(::Type{SSB}) = 0

struct SUN <: abstractStar end 
parent(::Type{SUN}) = SSB 
naif_id(::Type{SUN}) = 10
gravity(body::Type{SUN}, posRsph::Vector{Float64}) = CentralGravity(body, posRsph)
GM(::Type{SUN}) = bodvcd(10, "GM")[1]

#Generate Planetary Barycenters, their planet, and moons if included in tpc kernels
for i = 1:9
    barycentername = replace(bodc2n(i), " ", "_")
    barycentersymbol = Symbol(barycentername)
    planetname = bodc2n(i * 100 + 99)
    planetsymbol = Symbol(planetname)
    @eval begin 
        struct $barycentersymbol <: abstractBarycenter end
        parent(::Type{$barycentersymbol}) = SSB
        naif_id(::Type{$barycentersymbol}) = $i
        #println("Created: ", $barycentername, " With NAIF_ID of: ", naif_id($barycentersymbol))

        #do planet (i+99)
        struct $planetsymbol <: abstractPlanet end 
        parent(::Type{$planetsymbol}) = $barycentersymbol 
        naif_id(::Type{$planetsymbol}) = $i * 100 + 99
        GM(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "GM")[1]
        bodfnd($i * 100 + 99, "J2") ? J2(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "J2")[1] : J2(::Type{$planetsymbol}) = 0.
        bodfnd($i * 100 + 99, "J3") ? J3(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "J3")[1] : J3(::Type{$planetsymbol}) = 0.
        bodfnd($i * 100 + 99, "J4") ? J4(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "J4")[1] : J4(::Type{$planetsymbol}) = 0. 
        radii(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "RADII")
        equatorial_radius(::Type{$planetsymbol}) = radii($planetsymbol)[1]
        equatorial_radius_short(::Type{$planetsymbol}) = radii($planetsymbol)[2]
        polar_radius(::Type{$planetsymbol}) = radii($planetsymbol)[3]
        mean_radius(::Type{$planetsymbol}) = sum(radii($planetsymbol)) / 3
        frame(::Type{$planetsymbol}) = "IAU_" * bodc2n($i * 100 + 99)
        gravity(body::Type{$planetsymbol}, posRsph::Vector{Float64}) = CentralGravity(body, posRsph)
        altitude(body::Type{$planetsymbol}, posRsph::Vector{Float64}) = SphericalAltitude(body, posRsph)
        atmosphere(body::Type{$planetsymbol}, posRsph::Vector{Float64}, ep::Float64) = [0., 0., 0., 0.]
        density(body::Type{$planetsymbol}, posRsph::Vector{Float64}, ep::Float64) = atmosphere(body, posRsph, ep)[1]
        pressure(body::Type{$planetsymbol}, posRsph::Vector{Float64}, ep::Float64) = atmosphere(body, posRsph, ep)[2]
        temperature(body::Type{$planetsymbol}, posRsph::Vector{Float64}, ep::Float64) = atmosphere(body, posRsph, ep)[3]
        speedofsound(body::Type{$planetsymbol}, posRsph::Vector{Float64}, ep::Float64) = atmosphere(body, posRsph, ep)[4]
        #println("Created: ", $planetname, " With NAIF_ID of: ", naif_id($planetsymbol))
    end

    #scan for moons and add them 
    for j = 1:98
        #Only do something if the property GM can be found for the id that is being scanned
        if (bodfnd((i * 100 + j), "GM") && bodfnd(i * 100 + j, "RADII"))
            satellitename = bodc2n(i * 100 + j)
            satellitesymbol = Symbol(satellitename)
            @eval begin 
                struct $satellitesymbol <: abstractNaturalSatellite end 
                parent(::Type{$satellitesymbol}) = $barycentersymbol 
                naif_id(::Type{$satellitesymbol}) = $i * 100 + $j
                GM(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "GM")[1]
                bodfnd($i * 100 + $j, "J2") ? J2(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "J2")[1] : J2(::Type{$satellitesymbol}) = 0.
                bodfnd($i * 100 + $j, "J3") ? J3(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "J3")[1] : J3(::Type{$satellitesymbol}) = 0.
                bodfnd($i * 100 + $j, "J4") ? J4(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "J4")[1] : J4(::Type{$satellitesymbol}) = 0.
                radii(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "RADII")
                equatorial_radius(::Type{$satellitesymbol}) = radii($satellitesymbol)[1]
                equatorial_radius_short(::Type{$satellitesymbol}) = radii($satellitesymbol)[2]
                polar_radius(::Type{$satellitesymbol}) = radii($satellitesymbol)[3]
                mean_radius(::Type{$satellitesymbol}) = sum(radii($satellitesymbol)) / 3
                frame(::Type{$satellitesymbol}) = "IAU_" * bodc2n($i * 100 + $j)
                gravity(body::Type{$satellitesymbol}, posRsph::Vector{Float64}) = CentralGravity(body, posRsph)
                altitude(body::Type{$satellitesymbol}, posRsph::Vector{Float64}) = SphericalAltitude(body, posRsph)
                atmosphere(body::Type{$satellitesymbol}, posRsph::Vector{Float64}) = [0., 0., 0., 0.]
                density(body::Type{$satellitesymbol}, posRsph::Vector{Float64}) = atmosphere(body, posRsph)[1]
                pressure(body::Type{$satellitesymbol}, posRsph::Vector{Float64}) = atmosphere(body, posRsph)[2]
                temperature(body::Type{$satellitesymbol}, posRsph::Vector{Float64}) = atmosphere(body, posRsph)[3]
                speedofsound(body::Type{$satellitesymbol}, posRsph::Vector{Float64}) = atmosphere(body, posRsph)[4]
                #println("Created: ", $satellitename, " With NAIF_ID of: ", naif_id($satellitesymbol))
            end 
        end
    end     
end 

#Add general functions
#Compute the flattening of a CelestialBody
flattening(Body::Type{<:abstractCelestialBody}) = 1 - (polar_radius(Body) / equatorial_radius(Body))

#Helper state-transformation matrix function 
function BodyFixed2InertialState(Body::Type{T}, t::S) where {T <: abstractCelestialBody, S <: Real} 
    sxform(frame(Body), "J2000", Float64(t))
end 

function Inertial2BodyFixedState(Body::Type{T}, t::S) where {T <: abstractCelestialBody, S <: Real} 
    sxform("J2000", frame(Body), Float64(t))
end 

function BodyFixed2Inertial3(Body::Type{T}, t::S) where {T <: abstractCelestialBody, S <: Real} 
    pxform(frame(Body), "J2000", Float64(t))
end 

function Inertial2BodyFixed3(Body::Type{T}, t::S) where {T <: abstractCelestialBody, S <: Real} 
    pxform("J2000", frame(Body), Float64(t))
end 

function CelestialBodyState(FromBody::Type{T}, ToBody::Type{P}, t::S) where {T,P <: abstractCelestialBody, S <: Real} 
    spkezr(naif_id(FromBody), Float64(t), "J2000", naif_id(ToBody))[1]
end 

function CelestialBodyPosition(FromBody::Type{<: abstractCelestialBody}, ToBody::Type{<: abstractCelestialBody}, t::S) where {S <: Real} 
    spkpos(naif_id(FromBody), Float64(t), "J2000", naif_id(ToBody))[1]
end 