#Assume that the right kernels have been loaded that contain the relevant parameters. 
#also assume that atleast the planets (and pluto) and their respective bodies are included in the tpc kernels
using SPICE  #Just here for testing 
include("PlanetEnvironment.jl")
path = abspath(joinpath(dirname(@__FILE__), "../..", "resources"))
furnsh(["$path/pck00010.tpc","$path/Gravity.tpc"]...) #Just here for testing
include("CelestialBodies.jl")

warn("Include gravity, planet shape, and atmosphere models for each of the planets and moons")

#The barycenters of the solar system and planets systems (all are included)
struct SSB <: abstractBarycenter end
naif_id(::Type{SSB}) = 0

struct SUN <: abstractStar end 
parent(::Type{SUN}) = SSB 
naif_id(::Type{SUN}) = 10

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
        GM(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "GM")
        bodfnd($i * 100 + 99, "J2") ? J2(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "J2")[1] : nothing 
        bodfnd($i * 100 + 99, "J3") ? J3(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "J3")[1] : nothing 
        bodfnd($i * 100 + 99, "J4") ? J4(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "J4")[1] : nothing 
        radii(::Type{$planetsymbol}) = bodvcd($i * 100 + 99, "RADII")
        equatorial_radius(::Type{$planetsymbol}) = radii($planetsymbol)[1]
        equatorial_radius_short(::Type{$planetsymbol}) = radii($planetsymbol)[2]
        polar_radius(::Type{$planetsymbol}) = radii($planetsymbol)[3]
        mean_radius(::Type{$planetsymbol}) = sum(radii($planetsymbol)) / 3
        frame(::Type{$planetsymbol}) = "IAU_" * bodc2n($i * 100 + 99)
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
                GM(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "GM")
                bodfnd($i * 100 + $j, "J2") ? J2(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "J2")[1] : nothing 
                bodfnd($i * 100 + $j, "J3") ? J3(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "J3")[1] : nothing 
                bodfnd($i * 100 + $j, "J4") ? J4(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "J4")[1] : nothing 
                radii(::Type{$satellitesymbol}) = bodvcd($i * 100 + $j, "RADII")
                equatorial_radius(::Type{$satellitesymbol}) = radii($satellitesymbol)[1]
                equatorial_radius_short(::Type{$satellitesymbol}) = radii($satellitesymbol)[2]
                polar_radius(::Type{$satellitesymbol}) = radii($satellitesymbol)[3]
                mean_radius(::Type{$satellitesymbol}) = sum(radii($satellitesymbol)) / 3
                frame(::Type{$satellitesymbol}) = "IAU_" * bodc2n($i * 100 + $j)
                #println("Created: ", $satellitename, " With NAIF_ID of: ", naif_id($satellitesymbol))
            end 
        end
    end     
end 
