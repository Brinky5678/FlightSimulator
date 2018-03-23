include("PlanetEnvironment.jl")

#Define abstract enviroment type to allow for customization later.
abstract type AbstractEnvironment end

#Define the structure containing the PlanetEnvironments for each CelestialBody
struct Environment  <: AbstractEnvironment
    SunEnvironment::PlanetEnvironment
    MercuryEnvironment::PlanetEnvironment
    VenusEnvironment::PlanetEnvironment
    EarthEnvironment::PlanetEnvironment
    MoonEnvironment::PlanetEnvironment
    MarsEnvironment::PlanetEnvironment
    #CeresEnvironment::PlanetEnvironment
    JupiterEnvironment::PlanetEnvironment
    SaturnEnvironment::PlanetEnvironment
    UranusEnvironment::PlanetEnvironment
    NeptuneEnvironment::PlanetEnvironment
    PlutoEnvironment::PlanetEnvironment
    ReferenceFrame::Int64 #Will be its naif_id

    #= Make internal constructor that checks whether only 1 planet has been selected when
        the sun has not been selected, in which case an error is thrown.
        Moons are only allowed to be selected when their parent body is also selected.
    =#
    function Environment(SunEnv::PlanetEnvironment, MercuryEnv::PlanetEnvironment,
        VenusEnv::PlanetEnvironment, EarthEnv::PlanetEnvironment, MoonEnv::PlanetEnvironment,
        MarsEnv::PlanetEnvironment, JupiterEnv::PlanetEnvironment, SaturnEnv::PlanetEnvironment,
        UranusEnv::PlanetEnvironment, NeptuneEnv::PlanetEnvironment, PlutoEnv::PlanetEnvironment,
        ReferenceFrame::Type{<:AbstractFrame})

        #Do Check if two planets are selected without the Sun (Error occurs in function)
        TwoPlanetsWithoutSunSelected(SunEnv, MercuryEnv, VenusEnv, EarthEnv, MarsEnv,
         JupiterEnv, SaturnEnv, UranusEnv, NeptuneEnv, PlutoEnv)

        #Do Check if a moon has been selected without its parent (Error occurs in function)
        #Allow when Moon is the only thing selected.
        LonelyMoonSelected(SunEnv, MercuryEnv, VenusEnv, EarthEnv, MoonEnv, MarsEnv,
            JupiterEnv, SaturnEnv, UranusEnv, NeptuneEnv, PlutoEnv)

        #Check what reference frame will be the inertial frame
        if SunEnv.Included
            refframe = naif_id(SolarSystemBarycenter)
        else
            if MercuryEnv.Included
                refframe = naif_id(MercuryBarycenter)
            elseif VenusEnv.Included
                reffframe = naif_id(VenusBarycenter)
            elseif EarthEnv.Included && !MoonEnv.Included
                refframe = naif_id(Earth)
            elseif EarthEnv.Included && MoonEnv.Included
                refframe = naif_id(EarthBarycenter)
            elseif !EarthEnv.Included && MoonEnv.Included
                refframe = naif_id(Moon)
            elseif MarsEnv.Included
                refframe = naif_id(MarsBarycenter)
            elseif JupiterEnv.Included
                refframe = naif_id(JupiterBarycenter)
            elseif SaturnEnv.Included
                refframe = naif_id(SaturnBarycenter)
            elseif UranusEnv.Included
                refframe = naif_id(UranusBarycenter)
            elseif NeptuneEnv.Included
                refframe = naif_id(NeptuneBarycenter)
            elseif PlutoEnv.Included
               refframe = naif_id(Pluto)
            end
        end #If Sun.Included

        #Create object
        new(SunEnv, MercuryEnv, VenusEnv, EarthEnv, MoonEnv, MarsEnv, JupiterEnv, SaturnEnv,
         UranusEnv, NeptuneEnv, PlutoEnv, refframe)
    end #function Envrionment
end #struct Environment

#Alternative constructor function
function Environment(;SunEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    MercuryEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    VenusEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    EarthEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    MoonEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    MarsEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    JupiterEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    SaturnEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    UranusEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    NeptuneEnvironment::PlanetEnvironment = PlanetEnvironment(false),
    PlutoEnvironment::PlanetEnvironment = PlanetEnvironment(false))

    return Environment(SunEnvironment, MercuryEnvironment, VenusEnvironment,
        EarthEnvironment, MoonEnvironment, MarsEnvironment, JupiterEnvironment,
        SaturnEnvironment, UranusEnvironment, NeptuneEnvironment, PlutoEnvironment)
end #function Environment

function TwoPlanetsWithoutSunSelected(SunEnv::PlanetEnvironment, MercuryEnv::PlanetEnvironment,
    VenusEnv::PlanetEnvironment, EarthEnv::PlanetEnvironment,
    MarsEnv::PlanetEnvironment, JupiterEnv::PlanetEnvironment, SaturnEnv::PlanetEnvironment,
    UranusEnv::PlanetEnvironment, NeptuneEnv::PlanetEnvironment, PlutoEnv::PlanetEnvironment)

    #If true then more than one planet is selected without the Sun! Throw Error
    if ((!SunEnv.Included) &&
        sum(IncludedVector([MercuryEnv, VenusEnv, EarthEnv, MarsEnv, JupiterEnv, SaturnEnv,
            UranusEnv, NeptuneEnv, PlutoEnv])) >= 2)
        error("More than one planet selected without the Sun!")
    end
    return nothing
end #Function TwoPlanetsWithoutSunSelected

function LonelyMoonSelected(SunEnv::PlanetEnvironment, MercuryEnv::PlanetEnvironment,
    VenusEnv::PlanetEnvironment, EarthEnv::PlanetEnvironment, MoonEnv::PlanetEnvironment,
    MarsEnv::PlanetEnvironment, JupiterEnv::PlanetEnvironment, SaturnEnv::PlanetEnvironment,
    UranusEnv::PlanetEnvironment, NeptuneEnv::PlanetEnvironment, PlutoEnv::PlanetEnvironment)

    #Check if the moon has been selected with the Sun, but without the Earth
    if (SunEnv.Included && !EarthEnv.Included && MoonEnv.Included)
        error("The Moon has been selected without the Earth but with the Sun")
    end

    #Check if the Moon has been selected without the Sun, but without another planet.
    if (MoonEnv.Included && any(IncludedVector([MercuryEnv, VenusEnv, MarsEnv, JupiterEnv,
         SaturnEnv, UranusEnv, NeptuneEnv, PlutoEnv])))
        error("The Moon has been selected without the Earth but with another Planet")
    end
    return nothing
end #Function LonelyMoonSelected
